//
//  MyCollectionViewCell.h
//  CameraOverlay
//
//  Created by Baiqi Zhang on 4/28/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) NSString * imagePath;
@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) id coreData;

-(UIImage*) image;
-(void) initWithImagePath:(NSString*)imagePath;
-(BOOL)flip;

@end
