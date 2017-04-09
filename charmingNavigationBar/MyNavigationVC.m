//
//  MyNavigationVC.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MyNavigationVC.h"

@interface MyNavigationVC ()<UIGestureRecognizerDelegate>

@end

@implementation MyNavigationVC
//
+(void)load
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[UIViewController class]]];
    [bar setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:158 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:0.8]] forBarMetrics:UIBarMetricsDefault];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

    //如果在覆盖 backBarItem 的情况下，自定义返回图片就需要实现以下代码
    /*
    UIImage *backImg = [UIImage imageNamed:@"nav_back"];
    backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.backIndicatorImage = backImg;
    self.navigationBar.backIndicatorTransitionMaskImage = backImg;
    */
    
    // 如果不使用全局返回手势，又覆盖了leftBarItem，那么需要重新设置手势的代理为任何一个对象，这样系统的边缘侧滑手势就会重新启用
    /*
    self.interactivePopGestureRecognizer.delegate = someObject;
     */
   
       
    
}

#pragma mark - 给图片设置颜色
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
