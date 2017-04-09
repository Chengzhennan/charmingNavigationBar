//
//  _FDFullscreenPopGestureRecognizerDelegate.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "_FDFullscreenPopGestureRecognizerDelegate.h"
#import "UIViewController+FDFullscreenPopGesture.h"
@implementation _FDFullscreenPopGestureRecognizerDelegate

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    //如果是根控制器,不允许触发全局手势,如果触发了会造成假死现象.
    if (self.navigationController.viewControllers.count <= 1)
    {
        return NO;
    }
    
    //如果设置了该控制器不能使用手势,那么返回 NO;
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.fd_interactivePopDisabled)
    {
        return  NO;
    }
    
    //如果超过了设置的最大允许触发距离,返回 NO;
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ( topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge > 0 &&  beginningLocation.x > topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge)
    {
        return  NO;
    }

    //如果往左滑动, 返回 NO;
    if ([gestureRecognizer translationInView:gestureRecognizer.view].x <= 0)
    {
        return  NO;
    }
    
       
    return YES;
}



@end
