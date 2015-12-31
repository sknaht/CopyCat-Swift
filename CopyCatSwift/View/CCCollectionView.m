//
//  CCColectionView.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 7/12/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "CCCollectionView.h"

@implementation CCCollectionView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UIViewController *vc=(UIViewController*)self.delegate;
    [vc touchesBegan:touches withEvent:event];
}

@end
