//
//  DNPhotoBrowserViewController.m
//  ImagePicker
//
//  Created by DingXiao on 15/2/28.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "CCPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AVCamViewController.h"
//#import "LibraryViewController.h"
#import "MainViewController.h"

#import "DNSendButton.h"
#import "CCBrowserCell.h"

@interface CCPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *browserCollectionView;
@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIButton *checkButton;

@property (nonatomic, strong) NSMutableArray *photoDataSources;
@property (nonatomic, strong) NSMutableArray *cellList;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *flipButton;
@property (nonatomic, strong) UIButton *saveButton;




@end

@implementation CCPhotoBrowser

- (instancetype)initWithPhotos:(NSArray *)photosArray
                  currentIndex:(NSInteger)index{
    self = [super init];
    if (self) {
        _photoDataSources = [[NSMutableArray alloc] initWithArray:photosArray];
        _cellList=[[NSMutableArray alloc] initWithArray:photosArray];
        _currentIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.browserCollectionView setContentOffset:CGPointMake(self.browserCollectionView.frame.size.width * self.currentIndex,0)];
}

#pragma mark - priviate
- (void)setupView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.clipsToBounds = YES;
    [self browserCollectionView];
    
    //Buttons
    if ([self.delegate isKindOfClass:[LibraryViewController class]] || [self.delegate isKindOfClass:[AVCamViewController class]]){
        self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70)];
        self.bgView.backgroundColor=[UIColor blackColor];
        [self.view addSubview:self.bgView];
        
        self.cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height-65, 55, 55)];
        [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"close_highlight.png"] forState:UIControlStateHighlighted];
        [self.view addSubview:self.cancelButton];
        
        self.deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, self.view.frame.size.height-60, 45, 45)];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_highlight.png"] forState:UIControlStateHighlighted];
        [self.deleteButton addTarget:self action:@selector(performDelete) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deleteButton];
        
        _flipButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+15, self.view.frame.size.height-60, 45, 45)];
        [_flipButton setBackgroundImage:[UIImage imageNamed:@"flip2.png"] forState:UIControlStateNormal];
        [_flipButton setBackgroundImage:[UIImage imageNamed:@"flip2_highlight.png"] forState:UIControlStateHighlighted];
        [_flipButton addTarget:self action:@selector(flipAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_flipButton];
        
        _saveButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-60, self.view.frame.size.height-60, 45, 45)];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"save2.png"] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"save2_highlight.png"] forState:UIControlStateHighlighted];
        [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_saveButton];
    }
    
    if ([self.delegate isKindOfClass:[MainViewController class]]){
        UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
        bg.backgroundColor=[UIColor blackColor];
        [self.view addSubview:bg];
        
        UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4-23, self.view.frame.size.height-50, 50, 50)];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close_highlight.png"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeButton];
        
        UIButton *checkButton=[[UIButton alloc]initWithFrame:CGRectMake(3*self.view.frame.size.width/4-23, self.view.frame.size.height-50, 50, 50)];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"check_highlight.png"] forState:UIControlStateHighlighted];
        [checkButton addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkButton];
        
        UIView *bar=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-37.5, 1, 25)];
        bar.backgroundColor=[UIColor colorWithWhite:0.13 alpha:1];
        [self.view addSubview:bar];
    }
}

- (void)setupData
{
    self.photoDataSources = [NSMutableArray new];
}


#pragma mark - ui actions
-(void)saveAction{
    [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[self.currentImage CGImage] orientation:(ALAssetOrientation)[self.currentImage imageOrientation] completionBlock:nil];
    UILabel *notifyLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100,self.view.frame.size.height/2+150,200,30)];
    [notifyLabel setText:@"Photo saved"];
    [notifyLabel setTextColor:[UIColor whiteColor]];
    [notifyLabel setBackgroundColor:[UIColor blackColor]];
    [notifyLabel setAlpha:0];
    [self.view addSubview:notifyLabel];

    [UIView animateWithDuration:0.3 animations:^{
        [notifyLabel setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [notifyLabel setAlpha:0];
        } completion:^(BOOL finished) {
            [notifyLabel removeFromSuperview];
        }];
    }];
}

-(void)checkAction{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate isKindOfClass:[MainViewController class]])
        {
            NSLog(@"%@",self.currentImage);
            
            MainViewController *vc=self.delegate;
            [vc showOverlayViewWithImage:self.currentImage isNewImage:NO];
        }
    }];

}

-(void)cancelAction{
    if ([self.delegate isKindOfClass:[AVCamViewController class]]) {
        AVCamViewController *vc=self.delegate;
        if ([self.photoDataSources count]==0)
            [vc.libraryButton setBackgroundImage:nil forState:UIControlStateNormal];
        else{
            NSString* path=[NSString stringWithFormat:@"%@/Documents/Gallery/%@",NSHomeDirectory(),[self.photoDataSources lastObject]];
            UIImage *image=[[UIImage alloc]initWithContentsOfFile:path];
            
            [vc.libraryButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)flipAction{
    CCBrowserCell *cell=self.cellList[self.currentIndex];
    [cell flip];
}

- (void)performDelete{
    NSInteger index=self.currentIndex;
    if (index>[self.photoDataSources count]-1)
        return;
    
    NSString *path=[NSString stringWithFormat:@"%@/Documents/Gallery/%@",NSHomeDirectory(),self.photoDataSources[index]];
    [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    path=[NSString stringWithFormat:@"%@/Documents/GalleryRef/%@",NSHomeDirectory(),self.photoDataSources[index]];
    [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    
    [self.photoDataSources removeObjectAtIndex:index];
    if (index==[self.photoDataSources count])
        self.currentIndex--;
    
    [self.browserCollectionView reloadData];
}

#pragma mark - get/set

- (UICollectionView *)browserCollectionView
{
    if (nil == _browserCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _browserCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.bounds.size.width+20, self.view.bounds.size.height+1) collectionViewLayout:layout];
        _browserCollectionView.backgroundColor = [UIColor blackColor];
        [_browserCollectionView registerClass:[CCBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([CCBrowserCell class])];
        _browserCollectionView.delegate = self;
        _browserCollectionView.dataSource = self;
        _browserCollectionView.pagingEnabled = YES;
        _browserCollectionView.showsHorizontalScrollIndicator = NO;
        _browserCollectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_browserCollectionView];
    }
    return _browserCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.delegate isKindOfClass:[MainViewController class]])
        return [self.photoDataSources count]-1;
    else
        return [self.photoDataSources count];
}

- (CCBrowserCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCBrowserCell *cell = (CCBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CCBrowserCell class]) forIndexPath:indexPath];
    if (_cellList){
//        NSLog(@"%lu",indexPath.row);
        self.cellList[indexPath.row]=cell;
    }

    NSString *path;
    if ([self.delegate isKindOfClass:[LibraryViewController class]] || [self.delegate isKindOfClass:[AVCamViewController class]])
        path=[self.photoDataSources objectAtIndex:indexPath.row];
    else
        path=[NSString stringWithFormat:@"%@.jpg",[self.photoDataSources objectAtIndex:indexPath.row+1]];
    
    [cell initWithImagePath:path photoBrowser:self];

    cell.photoBrowser = self;

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width+20, self.view.bounds.size.height);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0f;
}

#pragma mark - scrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"x:%f",offsetX);

//    CGFloat itemWidth = CGRectGetWidth(self.browserCollectionView.frame);
//    CGFloat currentPageOffset = itemWidth * self.currentIndex;
//    CGFloat deltaOffset = offsetX - currentPageOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat itemWidth = CGRectGetWidth(self.browserCollectionView.frame);
    if (offsetX >= 0){
        NSInteger page = offsetX / itemWidth;
        self.currentIndex = page;
    }
}

#pragma mark - Control Hiding / Showing

- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated{
    if (hidden)
        [UIView animateWithDuration:0.15 animations:^{
            self.flipButton.alpha=0;
            self.cancelButton.alpha=0;
            self.deleteButton.alpha=0;
            self.saveButton.alpha=0;
            self.bgView.alpha=0;
        }];
    else
        [UIView animateWithDuration:0.15 animations:^{
            self.flipButton.alpha=1;
            self.cancelButton.alpha=1;
            self.deleteButton.alpha=1;
            self.saveButton.alpha=1;
            self.bgView.alpha=1;
        }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)areControlsHidden { return (_flipButton.alpha == 0); }
- (void)hideControls { [self setControlsHidden:YES animated:YES]; }
- (void)toggleControls { [self setControlsHidden:![self areControlsHidden] animated:YES]; }
@end
