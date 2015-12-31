    //
//  MyCollectionViewCell.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 4/28/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "CCCollectionViewCell.h"
#import "UIImage+Thumbnail.h"
#import "CCOverlayFrameView.h"
#import "CopyCatSwift-Swift.h"

@interface CCCollectionViewCell()

@property (strong,nonatomic) UIImageView * imageView;
@property (strong,nonatomic) UITextField * textField;
@property (strong,nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong,nonatomic) CCOverlayFrameView* overlayView;
@property BOOL deleteFlag;
@end

@implementation CCCollectionViewCell


-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state==UIGestureRecognizerStateBegan)
    {
        CCGalleryViewController * vc=self.delegate;
        [self flip];
        [vc prepareDelete];
        [vc prepareDeleteCell:self];
    }
}

-(BOOL)flip{
    if (!self.deleteFlag)
    {
        self.overlayView.alpha=1;
        self.imageView.alpha=0.5;
        self.deleteFlag=YES;
    }else{
        self.overlayView.alpha=0;
        self.imageView.alpha=1;
        self.deleteFlag=NO;
    }
    return self.deleteFlag;
}

-(UIImage*) getImageForPath:(NSString *)path{
    UIImage *image=[[UIImage alloc]initWithContentsOfFile:path];
    return image;
}

-(UIImage*) image{
    NSString *path=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),self.imagePath];
    UIImage* tmp=[self getImageForPath:path];
    if (!tmp)
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.imagePath]];
    else
        return tmp;
}

-(UIImage*) tmImage{
    NSString *path=[NSString stringWithFormat:@"%@/Documents/tm/%@.jpg",NSHomeDirectory(),self.imagePath];
    UIImage * tmImage=[self getImageForPath:path];
    if (!tmImage)
    {        
        tmImage=[[self image]thumbnailWithFactor:200];
        
        NSString *path=[NSString stringWithFormat:@"%@/Documents/tm/%@.jpg",NSHomeDirectory(),self.imagePath];
        NSData *imgData = UIImageJPEGRepresentation(tmImage,0.5);
        [imgData writeToFile:path atomically:YES];
    }
    return tmImage;
}

-(void) initWithImagePath:(NSString*)imagePath{
    self.deleteFlag=NO;
    self.imagePath=imagePath;
    if (!self.imageView)
    {
        self.imageView=[[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    self.imageView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
    self.imageView.alpha=0;
    
    if (!self.overlayView){
        self.overlayView=[[CCOverlayFrameView alloc]initWithFrame:self.imageView.frame];
        [self.overlayView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.overlayView];
    }
    self.overlayView.alpha=0;
    
    self.backgroundColor=[UIColor colorWithWhite:0.1 alpha:1];

    if (!self.longPress){
        self.longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        self.longPress.minimumPressDuration=0.5;
        [self addGestureRecognizer:self.longPress];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* tmImage=[self tmImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:tmImage];
            [UIView animateWithDuration:0.3 animations:^{
                self.imageView.alpha=1;
            }];
        });
    });
    
}

@end
