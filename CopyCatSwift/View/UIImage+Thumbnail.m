//
//  UIImage+Thumbnail.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 7/10/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage (Thumbnail)

- (UIImage *)thumbnail{
    UIImage* image=self;

    struct CGImage *tmCGImage;
    if (image.size.width>image.size.height)
        tmCGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake((image.size.width-image.size.height)/2.0, 0, image.size.height, image.size.height));
    else
        tmCGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, (image.size.height-image.size.width)/2.0, image.size.width, image.size.width));
    
    float factor=100;
    UIGraphicsBeginImageContext(CGSizeMake(factor, factor));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0,-1.0);
    CGContextTranslateCTM(context, 0, -factor);
    CGContextDrawImage(context, CGRectMake(0, 0, factor, factor),tmCGImage);
    UIImage *tmImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmImage;
}

- (UIImage *)resizeWithFactor:(float)factor{
    UIImage* image=self;
    
    struct CGImage *tmCGImage=[image CGImage];

    float width=image.size.width*factor,height=image.size.height*factor;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0,-1.0);
    CGContextTranslateCTM(context, 0, -height);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height),tmCGImage);
    UIImage *tmImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmImage;
}

- (UIImage *)thumbnailWithFactor:(float)factor{
    UIImage* image=self;
    
    struct CGImage *tmCGImage;
    if (image.size.width>image.size.height)
        tmCGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake((image.size.width-image.size.height)/2.0, 0, image.size.height, image.size.height));
    else
        tmCGImage=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, (image.size.height-image.size.width)/2.0, image.size.width, image.size.width));
    
    UIGraphicsBeginImageContext(CGSizeMake(factor, factor));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0,-1.0);
    CGContextTranslateCTM(context, 0, -factor);
    CGContextDrawImage(context, CGRectMake(0, 0, factor, factor),tmCGImage);
    UIImage *tmImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmImage;
}

- (UIImage *)zoomWithFactor:(float)factor{
    UIImage* image=self;
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0,-1.0);
    CGContextTranslateCTM(context, 0, -image.size.height);
    CGContextDrawImage(context, CGRectMake(-image.size.width*(factor-1)/2, -image.size.height*(factor-1)/2, image.size.width*factor, image.size.height*factor),[self CGImage]);
    UIImage *tmImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmImage;
}


@end
