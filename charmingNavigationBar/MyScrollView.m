//
//  MyScrollView.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

/*
 
 scrollView 的实现就是通过 pan 手势, 所以每个 scrollView内部都遵循UIGestureRecognizerDelegate,
 这里重写了UIGestureRecognizerDelegate的代理方法
 
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
