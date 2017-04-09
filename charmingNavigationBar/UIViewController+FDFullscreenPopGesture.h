//
//  UIViewController+FDFullscreenPopGesture.h
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FDFullscreenPopGesture)

/**设置全局返回手势是否可用,如果是 YES, 那么全局手势不能触发*/
@property (nonatomic,assign)BOOL fd_interactivePopDisabled;


/**允许触发侧滑返回的最大距离*/
@property (nonatomic,assign)CGFloat fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;


/**设置当前控制器的导航条是否隐藏*/
@property (nonatomic, assign) BOOL fd_prefersNavigationBarHidden;
;

@end
