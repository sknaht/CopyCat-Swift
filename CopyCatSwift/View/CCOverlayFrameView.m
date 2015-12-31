//
//  OverlayFrameView.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 7/21/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "CCOverlayFrameView.h"

@implementation CCOverlayFrameView
-(void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:65.0f/255.0f green:175.0f/255.0f blue:1 alpha:1] CGColor]);
    CGFloat x=rect.origin.x,y=rect.origin.y,width=rect.size.width,height=rect.size.height;
    float len=2.5;
    CGContextFillRect(context, CGRectMake(x, y, len, height));
    CGContextFillRect(context, CGRectMake(x, y, width, len));
    CGContextFillRect(context, CGRectMake(x+width-len, y, len, height));
    CGContextFillRect(context, CGRectMake(x,y+height-len, width, len));
}
@end
