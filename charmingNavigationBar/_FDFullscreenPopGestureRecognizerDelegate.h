//
//  _FDFullscreenPopGestureRecognizerDelegate.h
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _FDFullscreenPopGestureRecognizerDelegate : NSObject< UIGestureRecognizerDelegate>

///因为 navigationController 的 手势代理关联策略是OBJC_ASSOCIATION_RETAIN_NONATOMIC,所以这里避免循环引用,使用 weak
@property (nonatomic,weak)UINavigationController *navigationController;



@end
