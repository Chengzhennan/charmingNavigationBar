//
//  UINavigationController+FDFullscreenPopGesture.h
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (FDFullscreenPopGesture)

/**全局返回手势*/
@property (nonatomic,strong,readonly)UIPanGestureRecognizer *fd_fullscreenPopGestureRecognizer;

/**
  A view controller is able to control navigation bar's appearance by itself,
  rather than a global way, checking "fd_prefersNavigationBarHidden" property.
  Default to YES, disable it if you don't want so.
 
  导航条是全局的变量, 他的子控制器并不能控制他的导航条是否隐藏, 要通过
 [self.navigationController setNavigationBarHidden:<#(BOOL)#> animated:<#(BOOL)#>]方法设置是否隐藏导航条, 如果这个属性设置为 YES(默认也是 YES),那么可以在控制器下调用
 self.fd_prefersNavigationBarHidden = YES/NO; 直接控制导航条的隐藏;
 */
@property (nonatomic,assign)BOOL fd_viewControllerBasedNavigationBarAppearanceEnabled;






@end
