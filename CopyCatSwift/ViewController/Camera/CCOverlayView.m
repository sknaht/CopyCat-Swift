//
//  MyOverlayView.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 4/23/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "CCOverlayView.h"
#import "AVCamViewController.h"
#import "CopyCatSwift-Swift.h"

@interface CCOverlayView ()
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UISegmentedControl *segControl;
@property (strong,nonatomic) UIView *fakeView;
@property (nonatomic) BOOL rotateFlag;

@property (nonatomic) int overlayState;
@property (nonatomic) float savedAlpha;

@property (nonatomic) CGRect frame_bg;
@property (nonatomic) CGRect frame_tm;
@property (nonatomic) float lastPos;
@property (nonatomic) BOOL usingBackground;

@property (nonatomic,strong) UIView * fadeView;
@property (nonatomic,strong) UIImageView * dot;
@property (nonatomic,strong) UIImageView * swipeView;
@property BOOL stopAnimation;

@end

@implementation CCOverlayView

static float marginFactor=60.0f;
static float zoomFactor=10.0f;
static float sizeFactor=45.0f;

-(void)prepareAnimation{
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];;
    NSNumber *number=[userDefault objectForKey:@"isFirstTimeUser"];
    NSLog(@"%@",number);
    if (number)
        return;

    [userDefault setValue:[NSNumber numberWithInt:0] forKey:@"isFirstTimeUser"];
    [userDefault synchronize];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.fadeView.alpha=1;
    } completion:^(BOOL finished) {
        [self playAnimation];
    }];
}

-(void)finishAnimition{
    [UIView animateWithDuration:0.3 animations:^{
        self.dot.alpha=0;
        self.fadeView.alpha=0;
        self.swipeView.alpha=0;
    }];
    self.stopAnimation=YES;
}

-(void) playAnimation{
    if (self.stopAnimation)
        return ;
    //  1
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.dot.frame=CGRectMake(marginFactor, self.frame.size.height/3.0*2, sizeFactor, sizeFactor);
        self.dot.alpha=1;
    } completion:^(BOOL finished) {
        
        //      2
        if (self.stopAnimation)
            return ;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.dot.frame=CGRectMake(320-marginFactor-sizeFactor, self.frame.size.height/3.0*2, sizeFactor, sizeFactor);
            self.swipeView.alpha=1;
        } completion:^(BOOL finished) {
            
            //          3
            if (self.stopAnimation)
                return ;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.dot.frame=CGRectMake(320-marginFactor-sizeFactor-zoomFactor/2, self.frame.size.height/3.0*2-zoomFactor/2, sizeFactor+10, sizeFactor+10);
                self.dot.alpha=0;
            } completion:^(BOOL finished) {
                
                //              4
                if (self.stopAnimation)
                    return ;
                [UIView animateWithDuration:1 delay:0 options:0 animations:^{
                } completion:^(BOOL finished) {
                    self.dot.frame=CGRectMake(marginFactor-zoomFactor/2, self.frame.size.height/3.0*2-zoomFactor/2, sizeFactor+zoomFactor, sizeFactor+zoomFactor);
                    if (self.stopAnimation)
                        return ;
                    [self playAnimation];
                }];
            }];
            
        }];
    }];
}



-(void)onPress{
    switch (self.overlayState) {
        case 0:
            self.imageView.alpha=self.savedAlpha;
            self.overlayState=1;
            break;
        case 1:
            self.savedAlpha=self.imageView.alpha;
            self.imageView.alpha=0;
            self.overlayState=2;
            break;
        default:
            self.imageView.alpha=1;
            self.overlayState=0;
            break;
    };
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    if (self.usingBackground)
        return;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)handleCameraPinch:(UIPinchGestureRecognizer *)recognizer {
    float scale=recognizer.scale;

    AVCamViewController *AVCVC=self.delegate;
    [AVCVC cameraZoom:scale];

    recognizer.scale = 1;
}


- (void) handleOverlayTap:(UIPanGestureRecognizer*) recognizer
{
    if (self.usingBackground)
        return;
    self.imageView.transform=CGAffineTransformRotate(self.imageView.transform, -M_PI_2);
}



- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    if (self.usingBackground)
        return;
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self];
}

- (void) handlePanLR:(UIPanGestureRecognizer*) recognizer
{
    [self finishAnimition];

    CGPoint translation = [recognizer translationInView:self];
    if (recognizer.state==UIGestureRecognizerStateBegan)
        self.lastPos=translation.x;
    else
    {
        self.imageView.alpha+=(translation.x-self.lastPos)/250.0;
        if (self.imageView.alpha<0)
            self.imageView.alpha=0;
        if (self.imageView.alpha>1)
            self.imageView.alpha=1;
        self.lastPos=translation.x;
    }

}


- (void) handleTap:(UIPanGestureRecognizer*) recognizer
{
    AVCamViewController *AVCVC=self.delegate;

    [AVCVC focusAndExposeTap:recognizer withFlag:self.rotateFlag];
}

-(void)onSegChanged{
    if ([CCCoreUtil isUsingBackgrondMode]){
        self.imageView.frame=self.frame_bg;
        self.imageView.alpha=0.2;
        [self bringSubviewToFront:self.fakeView];
        self.usingBackground=YES;
    }else{
        self.imageView.frame=self.frame_tm;
        self.imageView.alpha=0.9;
        [self bringSubviewToFront:self.imageView];
        self.usingBackground=NO;
    }
}


-(instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image{
    self=[self initWithFrame:frame];
    
    self.overlayState=1;
    
    float height=frame.size.height-140,width=frame.size.width;
    self.frame_bg=CGRectMake(0,40,width,height);
    float ratio=(float)width/(float)height;
    
    int thumbnailSize=150;
    if (image.size.width>image.size.height)
        self.frame_tm=CGRectMake(self.frame.size.width/2-image.size.height/image.size.width*thumbnailSize/2,self.frame.size.height/2-thumbnailSize,image.size.height/image.size.width*thumbnailSize,thumbnailSize);
    else
        self.frame_tm=CGRectMake(self.frame.size.width/2,self.frame.size.height/2-image.size.height/image.size.width*thumbnailSize/2,thumbnailSize,image.size.height/image.size.width*thumbnailSize);
    

    self.backgroundColor = [UIColor clearColor];
    
    self.transparencyButton=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-80, frame.size.height-70, 50, 50)];
    [self addSubview:self.transparencyButton];
    [self.transparencyButton addTarget:self action:@selector(onPress) forControlEvents:UIControlEventTouchUpInside];
    [self.transparencyButton setBackgroundImage:[UIImage imageNamed:@"transparency.png"] forState:UIControlStateNormal];

    
    struct CGImage *CGImage;
    
    if (image.size.width>image.size.height)
    {
        if (image.size.width*ratio>image.size.height)
            CGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake((image.size.width-(float)image.size.height/ratio)/2.0, 0,  (float)image.size.height/ratio,image.size.height));
        else
            CGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, (image.size.height-(float)image.size.width*ratio)/2.0, image.size.width, image.size.width*ratio));
    }
    else
    {
        if (image.size.height*ratio>image.size.width)
            CGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0,(image.size.height-(float)image.size.width/ratio)/2.0,image.size.width, (float)image.size.width/ratio));
       else
            CGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake((image.size.width-(float)image.size.height*ratio)/2.0, 0, image.size.height*ratio, image.size.height));
    }

    if (image.size.width>image.size.height)
    {
        frame=self.frame_bg;
        UIGraphicsBeginImageContext(frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextRotateCTM(context, 90.0/180.0*3.1415926f);
        CGContextScaleCTM(context, 1.0,-1.0);
        CGContextDrawImage(context, CGRectMake(0, 0, frame.size.height, frame.size.width),CGImage);
        
        image= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        frame=self.frame_bg;
        UIGraphicsBeginImageContext(frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(context, 1.0,-1.0);
        CGContextTranslateCTM(context, 0.0, -frame.size.height);
        CGContextDrawImage(context, CGRectMake(0, 0, frame.size.width, frame.size.height),CGImage);
        
        image= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
   
    self.image=image;
    self.imageView=[[UIImageView alloc]initWithImage:image];
    self.imageView.userInteractionEnabled=YES;

    [self addSubview:self.imageView];
    
    self.fakeView=[[UIView alloc]initWithFrame:self.frame_bg];
    [self.fakeView setUserInteractionEnabled:YES];
    [self addSubview:self.fakeView];
    
    [self onSegChanged];
    
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UIPinchGestureRecognizer* pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    UITapGestureRecognizer* overlayTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOverlayTap:)];
    
    [self.imageView addGestureRecognizer:panGestureRecognizer];
    [self.imageView addGestureRecognizer:pinchGestureRecognizer];
    [self.imageView addGestureRecognizer:overlayTapGestureRecognizer];

    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UIPanGestureRecognizer* panLRGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanLR:)];
    UIPinchGestureRecognizer* cameraPinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleCameraPinch:)];

    [self.fakeView addGestureRecognizer:panLRGestureRecognizer];
    [self.fakeView addGestureRecognizer:tapGestureRecognizer];
    [self.fakeView addGestureRecognizer:cameraPinchGestureRecognizer];
    
    
    
    self.fadeView=[[UIView alloc]initWithFrame:self.frame];
    [self.fadeView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    self.fadeView.userInteractionEnabled=false;
    self.fadeView.alpha=0;
    [self addSubview:self.fadeView];
    
    self.swipeView=[[UIImageView alloc]initWithFrame:CGRectMake(320-marginFactor-sizeFactor-zoomFactor/2, self.frame.size.height/3.0*2+sizeFactor+5,60, 17.5)];
    self.swipeView.image=[UIImage imageNamed:@"swipe.png"];
    self.swipeView.alpha=0;
    [self addSubview:self.swipeView];
    
    self.dot=[[UIImageView alloc]initWithFrame:CGRectMake(marginFactor-zoomFactor/2, self.frame.size.height/3.0*2-zoomFactor/2, sizeFactor+zoomFactor, sizeFactor+zoomFactor)];
    self.dot.image=[UIImage imageNamed:@"whitedot.png"];
    self.dot.alpha=0;
    [self addSubview:self.dot];

    self.stopAnimation=NO;

    return self;
}

@end


