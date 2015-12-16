//
//  ViewController.m
//  PAImagePlayerView
//
//  Created by 小飞 刘 on 12/15/15.
//  Copyright © 2015 app. All rights reserved.
//

#import "ViewController.h"
#import "PAImagePlayerView.h"

@interface ViewController ()<PAImagePlayerViewDataSource,PAImagePlayerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PAImagePlayerView *playerView = [[PAImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) scrollDirection:UICollectionViewScrollDirectionHorizontal];
    playerView.pa_DataSource = self;
    playerView.pa_Delegate = self;
    [playerView pa_setCurrentIndex:1];
    [playerView pa_setAutoPerformAnimationScroll:YES];
    [self.view addSubview:playerView];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- PAImagePlayerViewDataSource

- (NSInteger)numberOfPagesInPAImagePlayerView:(PAImagePlayerView*)paImagePlayerView
{
    return 5;
}

- (UIView*)customViewInPAImagePlayerView:(PAImagePlayerView*)paImagePlayerView atIndex:(NSInteger)index
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paImagePlayerView.frame.size.width, paImagePlayerView.frame.size.height)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, paImagePlayerView.frame.size.width, paImagePlayerView.frame.size.height)];
    [backgroundImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"img%d.png",(int)index + 1]]];
    [customView addSubview:backgroundImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,100, paImagePlayerView.frame.size.width, 30)];
    titleLabel.text = [NSString stringWithFormat:@"Custom Title %d",(int)index];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:titleLabel];
    
    return customView;
}

#pragma mark -- PAImagePlayerViewDelegate

- (BOOL)PAImagePlayerView:(PAImagePlayerView*)paImagePlayerView shouldSelectAtIndex:(NSInteger)index
{
    return NO;
}

- (void)PAImagePlayerView:(PAImagePlayerView*)paImagePlayerView didSelectAtIndex:(NSInteger)index
{
    NSLog(@"playerView %@ index %d",paImagePlayerView,(int)index);
}

@end
