//
//  PreviewViewController.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 5/14/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "CCPreviewViewController.h"
#import "UIImage+fixOrientation.h"
#import "CopyCatSwift-Swift.h"


@interface CCPreviewViewController ()
@property (strong,nonatomic) UIImage * image;
@property (strong,nonatomic) UIImage  * refImage;
@property (strong,nonatomic) UIImageView * imageView;
@property (strong,nonatomic) UIImageView * refImageView;

@property BOOL isShowingRef;

@property (strong,nonatomic) UIButton *acceptButton;
@property (strong,nonatomic) UIButton *cancelButton;
@property (strong,nonatomic) UIButton *flipButton;

// Rotation
@property(nonatomic,strong) CMMotionManager * motionManager;
@property(nonatomic) NSInteger imageOrientation;
@property(nonatomic) NSInteger orientation;
@property(nonatomic) float ratio1,ratio2;

@end

@implementation CCPreviewViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)saveImage{
    AVCamViewController *vc=self.delegate;
    vc.libraryButton.enabled=NO;
    vc.stillButton.enabled=NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* image=self.image;
        UIImage* tmImage=[image thumbnailWithFactor:200];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc.libraryButton setBackgroundImage:tmImage forState:UIControlStateNormal];
        });

        if ([CCCoreUtil isSaveToCameraRoll])
        {
            [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
            NSLog(@"Save to Camera Roll");
        }

        [CCCoreUtil addUserPhoto:image refImage:self.refImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            vc.libraryButton.enabled=YES;
            vc.stillButton.enabled=YES;
        });

    });
        
    [self dismissSelf];
}

-(void)dismissSelf{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)onFlipPress{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isShowingRef)
        {
            self.imageView.alpha=1;
            self.refImageView.alpha=0;
            self.isShowingRef=NO;

        }else{
            self.imageView.alpha=0;
            self.refImageView.alpha=1;
            self.isShowingRef=YES;
        }
    }];
}

- (instancetype)initWithImage:(UIImage*)image withReferenceImage:(UIImage*)refImage orientation:(NSInteger)orientation{
    self=[super init];
    if (self)
    {
        self.image=image;
        self.refImage=refImage;
        self.imageOrientation=orientation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.13f alpha:1]];
    
    // Rotation
    self.motionManager=[[CMMotionManager alloc]init];
    [self.motionManager setDeviceMotionUpdateInterval:0.1];
    self.orientation=0;

    self.acceptButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height-85, 80, 80)];
    [self.acceptButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self.acceptButton setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.acceptButton];
    
    self.cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height-70, 55, 55)];
    [self.cancelButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"close_highlight.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.cancelButton];
    
    self.flipButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height-70, 55, 55)];
    [self.flipButton addTarget:self action:@selector(onFlipPress) forControlEvents:UIControlEventTouchUpInside];
    [self.flipButton setBackgroundImage:[UIImage imageNamed:@"flip2.png"] forState:UIControlStateNormal];
    [self.flipButton setBackgroundImage:[UIImage imageNamed:@"flip2_highlight.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.flipButton];

    self.isShowingRef=NO;
    
    float height=self.view.frame.size.height-140,width=self.view.frame.size.width;
    CGRect frame_bg=CGRectMake(0,40,width,height);

    UIView *backgroundView=[[UIView alloc]initWithFrame:frame_bg];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:backgroundView];
    
    self.imageView=[[UIImageView alloc]initWithFrame:frame_bg];
    self.imageView.image=self.image;
    [self.view addSubview:self.imageView];

    self.refImageView=[[UIImageView alloc]initWithFrame:frame_bg];
    self.refImageView.image=self.refImage;
    self.refImageView.alpha=0;
    [self.view addSubview:self.refImageView];

    

    if (self.imageView.image.size.width>self.imageView.image.size.height){
        self.imageView.frame=CGRectMake(frame_bg.origin.x+frame_bg.size.width/2-frame_bg.size.height/2, frame_bg.origin.y+frame_bg.size.height/2-frame_bg.size.width/2, frame_bg.size.height, frame_bg.size.width);

        CGAffineTransform transform;
        self.ratio1=self.imageView.frame.size.height/self.imageView.frame.size.width;
        self.ratio2=1;
        
        switch (self.imageOrientation) {
            case -1:
                self.orientation=-1;
                self.cancelButton.transform=CGAffineTransformMakeRotation(M_PI_2);
                self.acceptButton.transform=CGAffineTransformMakeRotation(M_PI_2);
                self.flipButton.transform=CGAffineTransformMakeRotation(M_PI_2);

                transform=CGAffineTransformMakeRotation(M_PI_2);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio2, _ratio2);
                break;
            case 1:
                self.orientation=1;
                self.cancelButton.transform=CGAffineTransformMakeRotation(-M_PI_2);
                self.acceptButton.transform=CGAffineTransformMakeRotation(-M_PI_2);
                self.flipButton.transform=CGAffineTransformMakeRotation(-M_PI_2);

                transform=CGAffineTransformMakeRotation(-M_PI_2);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio2, _ratio2);
                break;
            default:
                break;
        }
        
        self.imageOrientation=0;

    } else{
        self.ratio1=1;
        self.ratio2=self.imageView.frame.size.width/self.imageView.frame.size.height;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (motion.gravity.x>0.5f)
            [self rotateLeft];
        else if (motion.gravity.x<-0.5f)
            [self rotateRight];
        else if (motion.gravity.x>-0.3f&&motion.gravity.x<0.3f)
            [self rotateUpright];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.motionManager stopDeviceMotionUpdates];
}

-(void)rotateUpright{
    if (self.orientation==0)
        return;
    [UIView animateWithDuration:0.3 animations:^{
        self.acceptButton.transform=CGAffineTransformMakeRotation(0);
        self.cancelButton.transform=CGAffineTransformMakeRotation(0);
        self.flipButton.transform=CGAffineTransformMakeRotation(0);
        CGAffineTransform transform;
        switch (self.imageOrientation) {
            case 0:
                transform=CGAffineTransformMakeRotation(0);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio1, _ratio1);
                break;
            case -1:
                transform=CGAffineTransformMakeRotation(-M_PI_2);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio2, _ratio2);
                break;
            case 1:
                transform=CGAffineTransformMakeRotation(M_PI_2);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio2, _ratio2);
                break;
            default:
                break;
        }
        
    }];
    self.orientation=0;
}

-(void)rotateLeft{
    if (self.orientation==1)
        return;
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelButton.transform=CGAffineTransformMakeRotation(-M_PI_2);
        self.acceptButton.transform=CGAffineTransformMakeRotation(-M_PI_2);
        self.flipButton.transform=CGAffineTransformMakeRotation(-M_PI_2);
        CGAffineTransform transform;
        switch (self.imageOrientation) {
            case 1:
                transform=CGAffineTransformMakeRotation(0);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio1, _ratio1);
                break;
            case 0:
                transform=CGAffineTransformMakeRotation(-M_PI_2);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio2, _ratio2);
                break;
            case -1:
                transform=CGAffineTransformMakeRotation(-M_PI);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio1, _ratio1);
                break;
            default:
                break;
        }

    }];
    self.orientation=1;
}

-(void)rotateRight{
    if (self.orientation==-1)
        return;
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelButton.transform=CGAffineTransformMakeRotation(M_PI_2);
        self.acceptButton.transform=CGAffineTransformMakeRotation(M_PI_2);
        self.flipButton.transform=CGAffineTransformMakeRotation(M_PI_2);
        CGAffineTransform transform;
        switch (self.imageOrientation) {
            case -1:
                transform=CGAffineTransformMakeRotation(0);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio1, _ratio1);
                break;
            case 0:
                transform=CGAffineTransformMakeRotation(M_PI_2);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio2, _ratio2);
                break;
            case 1:
                transform=CGAffineTransformMakeRotation(M_PI);
                self.imageView.transform=CGAffineTransformScale(transform, _ratio1, _ratio1);
                break;
            default:
                break;
        }

    }];
    self.orientation=-1;
}


@end
