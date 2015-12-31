//
//  DNBrowserCell.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/28.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCPhotoBrowser;

@interface CCBrowserCell : UICollectionViewCell

@property (nonatomic, strong) CCPhotoBrowser *photoBrowser;

@property (nonatomic,strong) UIImage* image;

-(void) initWithImagePath:(NSString*)imagePath photoBrowser:(CCPhotoBrowser*)photoBrowser;

-(void)flip;

@end
