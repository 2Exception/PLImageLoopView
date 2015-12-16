//
//  PAImagePlayerView.h
//  PAImagePlayerView
//
//  Created by pauleryliu on 12/15/15.
//  Copyright © 2015 app. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAImagePlayerView;

#define PAGECONTROL_FROM_BOTTOM 30
#define PAGECONTROL_HEIGHT      20
#define ANIMATION_INTERVAL      2

typedef NS_ENUM(NSInteger, paScrollAnimationType) {
    paScrollAnimationDefault,
};

//_______________________________________________________________________________________________

@protocol PAImagePlayerViewDataSource <NSObject>
@required
- (NSInteger)numberOfPagesInPAImagePlayerView:(PAImagePlayerView*)paImagePlayerView;
- (UIView*)customViewInPAImagePlayerView:(PAImagePlayerView*)paImagePlayerView atIndex:(NSInteger)index;
@end

//_______________________________________________________________________________________________

@protocol PAImagePlayerViewDelegate <NSObject>
@optional
- (BOOL)PAImagePlayerView:(PAImagePlayerView*)paImagePlayerView shouldSelectAtIndex:(NSInteger)index;
- (void)PAImagePlayerView:(PAImagePlayerView*)paImagePlayerView didSelectAtIndex:(NSInteger)index;
@end

//_______________________________________________________________________________________________

@interface PAImagePlayerView : UICollectionView

@property (nonatomic, weak) id<PAImagePlayerViewDataSource> pa_DataSource;
@property (nonatomic, weak) id<PAImagePlayerViewDelegate> pa_Delegate;
@property (nonatomic, strong) UIPageControl *pageControl;

// init , default scroll direction is horizontal
- (id)initWithFrame:(CGRect)frame;
// init with scroll direction
- (id)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
// set current index
- (void)pa_setCurrentIndex:(NSInteger)currentIndex;
// set auto scroll , default is YES
- (void)pa_setAutoPerformAnimationScroll:(BOOL)isAutoAnimationScroll;
// set auto scroll interval , default is 2 seconds
- (void)pa_setAutoPerformAnimationScrollInterval:(NSTimeInterval)animationInterval;

// set scoll animation type
//- (void)pa_setAutoPerformScrollAnimationType:(paScrollAnimationType)animationType;

@end
