//
//  BZFramedButton.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 7/9/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "CCFramedButton.h"

@implementation CCFramedButton

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self setTitleColor:[UIColor colorWithRed:65.0/255.0 green:175.0/255.0 blue:1 alpha:1] forState:UIControlStateHighlighted];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CALayer *layer=self.layer;
    layer.borderWidth=0.5;
    layer.borderColor=[[UIColor colorWithWhite:0.5 alpha:1] CGColor];
}

@end
