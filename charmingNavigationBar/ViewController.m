//
//  ViewController.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "Pushed1ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBackBarButtonItem];
}

-(void)setupBackBarButtonItem
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"backBarItem";
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(8, 0) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = backItem;
}



- (IBAction)backBarButtonItemClick:(id)sender
{
    
    Pushed1ViewController *pushed1 = [[Pushed1ViewController alloc]init];

    [self.navigationController pushViewController:pushed1 animated:YES];
    
}



- (IBAction)leftBarButtonItemClick:(id)sender
{
    
    Pushed1ViewController *pushed1 = [[Pushed1ViewController alloc]init];
    pushed1.backType = BackTypeLeftItem;
    
    [self.navigationController pushViewController:pushed1 animated:YES];
    
}


- (IBAction)popGestureClick:(id)sender
{
    
    Pushed1ViewController *pushed1 = [[Pushed1ViewController alloc]init];
    
    [self.navigationController pushViewController:pushed1 animated:YES];
    
    
}










@end
