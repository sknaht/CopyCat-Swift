//
//  MyOverlayView.h
//  CameraOverlay
//
//  Created by Baiqi Zhang on 4/23/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCOverlayView : UIView

@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) UIImagePickerController * picker;
@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) UIButton *transparencyButton;

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image;
-(void)prepareAnimation;
@end
