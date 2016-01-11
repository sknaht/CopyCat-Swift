//
//  DNPhotoBrowserViewController.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/28.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCPhotoBrowser;

@interface CCPhotoBrowser : UIViewController

@property (nonatomic, weak) id delegate;

@property (nonatomic,strong) UIImage * currentImage;

- (instancetype)initWithPhotos:(NSArray *)photosArray
                  currentIndex:(NSInteger)index;

- (void)hideControls;
- (void)toggleControls;
@end
