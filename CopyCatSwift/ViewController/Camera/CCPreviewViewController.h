//
//  PreviewViewController.h
//  CameraOverlay
//
//  Created by Baiqi Zhang on 5/14/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>
#import "AVCamViewController.h"
#import "UIImage+Thumbnail.h"

@interface CCPreviewViewController : UIViewController

@property (weak,nonatomic) id delegate;

- (instancetype)initWithImage:(UIImage*)image withReferenceImage:(UIImage*)refImage orientation:(NSInteger)orientation;

@end
