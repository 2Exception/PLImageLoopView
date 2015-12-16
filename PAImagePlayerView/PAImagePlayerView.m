//
//  PAImagePlayerView.m
//  PAImagePlayerView
//
//  Created by pauleryliu on 12/15/15.
//  Copyright © 2015 app. All rights reserved.
//

#import "PAImagePlayerView.h"

static NSString * const reuseIndentifier = @"cellIndentifier";

@interface PAImagePlayerView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger numberOfPages;

// auto prefrom animation scroll
@property (nonatomic, assign) BOOL isAutoAnimationScroll;
@property (nonatomic, assign) paScrollAnimationType animationType;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationInterval;

@end

@implementation PAImagePlayerView

- (void)dealloc
{
    [self stopAnimation];
}

// init , default scroll direction is horizontal
- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
    }
    return self;
}

// init with scroll direction
- (id)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:scrollDirection];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.delegate = self;
    self.dataSource = self;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    [self initData];
    [self initPageControl];
    [self initAnimationTimer];
    
    self.contentOffset = CGPointMake(_pageControl.currentPage * self.frame.size.width, self.contentOffset.y);
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIndentifier];
    
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark -- private method

- (void)initData
{
    _numberOfPages = 0;
    if ([self.pa_DataSource respondsToSelector:@selector(numberOfPagesInPAImagePlayerView:)]) {
        _numberOfPages = [self.pa_DataSource numberOfPagesInPAImagePlayerView:self];
    }
}

- (void)initPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - PAGECONTROL_FROM_BOTTOM, self.frame.size.width, PAGECONTROL_HEIGHT)];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    if (_numberOfPages > 1) {
        _pageControl.numberOfPages = _numberOfPages;
    } else {
        [_pageControl setHidden:YES];
    }
    _pageControl.currentPage = _currentIndex;
    [self.superview addSubview:_pageControl];
}

- (void)initAnimationTimer
{
    if (_isAutoAnimationScroll && _numberOfPages > 1) {
        if (_animationInterval == 0) {
            _animationInterval = ANIMATION_INTERVAL;
        }
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationInterval target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    }
}

- (void)startAnimation
{
    // pageControll
    if (_pageControl.currentPage == _pageControl.numberOfPages - 1) {
        _pageControl.currentPage = 0;
    } else {
        _pageControl.currentPage++;
    }
    
    // contentOffset
    self.contentOffset = CGPointMake(_pageControl.currentPage * self.frame.size.width, self.contentOffset.y);
}

- (void)stopAnimation
{
    [_animationTimer fire];
    _animationTimer = nil;
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.pa_DataSource respondsToSelector:@selector(numberOfPagesInPAImagePlayerView:)]) {
        return [self.pa_DataSource numberOfPagesInPAImagePlayerView:self];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIndentifier forIndexPath:indexPath];
    
    if ([self.pa_DataSource respondsToSelector:@selector(customViewInPAImagePlayerView:atIndex:)]) {
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.contentView addSubview:[self.pa_DataSource customViewInPAImagePlayerView:self atIndex:indexPath.row]];
        
    } else {
        [cell.contentView addSubview:[[UIView alloc] init]];
    }
    return cell;
}

#pragma mark -- UICollectionViewDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pa_Delegate respondsToSelector:@selector(PAImagePlayerView:shouldSelectAtIndex:)]) {
        return [self.pa_Delegate PAImagePlayerView:self shouldSelectAtIndex:indexPath.row];
    } else {
       return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pa_Delegate respondsToSelector:@selector(PAImagePlayerView:didSelectAtIndex:)]) {
        return [self.pa_Delegate PAImagePlayerView:self didSelectAtIndex:indexPath.row];
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s %f",__FUNCTION__,scrollView.contentOffset.x);
    int currentPage = scrollView.contentOffset.x / self.frame.size.width;
    _pageControl.currentPage = currentPage;
}

#pragma mark -- Propreties

// set current index
- (void)pa_setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}

// set auto scroll , default is YES
- (void)pa_setAutoPerformAnimationScroll:(BOOL)isAutoAnimationScroll;
{
    _isAutoAnimationScroll = isAutoAnimationScroll;
}

// set auto scroll interval , default is 2 seconds
- (void)pa_setAutoPerformAnimationScrollInterval:(NSTimeInterval)animationInterval;
{
    if (animationInterval == 0) {
        _animationInterval = ANIMATION_INTERVAL;
    } else {
        _animationInterval = animationInterval;
    }
}

// set scoll animation type
//- (void)pa_setAutoPerformScrollAnimationType:(paScrollAnimationType)animationType;
//{
//    _animationType = animationType;
//}

@end
