//
//  UIImage+Thumbnail.h
//  CameraOverlay
//
//  Created by Baiqi Zhang on 7/10/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnail)
- (UIImage *)thumbnail;
- (UIImage *)thumbnailWithFactor:(float)factor;
- (UIImage *)resizeWithFactor:(float)factor;
- (UIImage *)zoomWithFactor:(float)factor;

@end
