//
//  Pushed1ViewController.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "Pushed1ViewController.h"

@interface Pushed1ViewController ()

@end

@implementation Pushed1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];

}

-(void)setupNavigationBar
{
    if (_backType  == BackTypeLeftItem)
    {
        [self setupLeftBarButtonItem];

    }
}




-(void)setupLeftBarButtonItem
{
    
    UIButton *lefuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lefuButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [lefuButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [lefuButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    [lefuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lefuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [lefuButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [lefuButton setTitle:@"leftBarItem" forState:UIControlStateNormal] ;
    [lefuButton sizeToFit];
    [lefuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lefuButton];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];

}













@end
