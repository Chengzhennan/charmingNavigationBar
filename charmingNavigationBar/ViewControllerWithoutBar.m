//
//  ViewControllerWithoutBar.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewControllerWithoutBar.h"
#import "ViewControllerWithoutBar2.h"
#import "UIViewController+FDFullscreenPopGesture.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewControllerWithoutBar ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIView *navigationView;
//保存页面消失前的导航条透明度
@property (nonatomic,assign)CGFloat localAlpha;

@end

@implementation ViewControllerWithoutBar

- (void)viewDidLoad
{
    [super viewDidLoad];

    

    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    [self initScrollView];
    [self initNavigationBar];
    
    
    
}



-(void)initScrollView
{
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setTitle:@"pushNextVC" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [pushBtn sizeToFit];
    pushBtn.center = CGPointMake(ScreenW * 0.5, ScreenH * 0.5);

    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollV.contentSize = CGSizeMake(0, ScreenH * 2);
    scrollV.delegate = self;
    [scrollV addSubview: pushBtn];

    

    [self.view addSubview:scrollV];

}

-(void)initNavigationBar
{

    _navigationView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    _navigationView.backgroundColor = [UIColor orangeColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn sizeToFit];
    backBtn.center = CGPointMake(40, _navigationView.frame.size.height * 0.68);
    [_navigationView addSubview:backBtn];
    
    
    [self.view addSubview:_navigationView];
    

}



#pragma mark -  scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    // 获取当前最新偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 计算当前的透明度
    CGFloat alpha = offsetY /  (264);
    
    if (alpha > 1)
    {
        alpha = 0.99;
    }
    self.localAlpha = alpha;
    
    
    [self handleNavigationBarAlpha];
    
}


-(void)handleNavigationBarAlpha
{
    _navigationView.alpha = self.localAlpha;
}

-(void)push
{
    ViewControllerWithoutBar2 *nextVC = [[ViewControllerWithoutBar2 alloc]init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
