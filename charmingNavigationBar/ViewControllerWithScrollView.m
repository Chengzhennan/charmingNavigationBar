//
//  ViewControllerWithScrollView.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewControllerWithScrollView.h"
#import "MyScrollView.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewControllerWithScrollView ()

@end

@implementation ViewControllerWithScrollView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initScrollView];
    
}

-(void)initScrollView
{
    
    MyScrollView *scrollV = [[MyScrollView alloc]initWithFrame:self.view.bounds];
    scrollV.contentSize = CGSizeMake(ScreenW * 2,ScreenH * 2);
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"这里是 ScrollView";
    [label sizeToFit];
    label.center = CGPointMake(ScreenW * 0.5, ScreenH * 0.5);
    [scrollV addSubview:label];
    [self.view addSubview:scrollV];
    
}






@end
