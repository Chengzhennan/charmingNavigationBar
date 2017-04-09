//
//  UINavigationController+FDFullscreenPopGesture.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//
#import <objc/runtime.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "_FDFullscreenPopGestureRecognizerDelegate.h"
#import "UIViewController+FDFullscreenPopGesture.h"

#pragma mark -  为 UIViewController 添加一个私有的分类
typedef void(^_FDViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (FDFullscreenPopGesturePrivate)

@property (nonatomic, copy) _FDViewControllerWillAppearInjectBlock fd_willAppearInjectBlock;
@end

@implementation UIViewController (FDFullscreenPopGesturePrivate)

//交换viewWillAppear 方法的实现
+(void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(fd_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        //为 UIViewController 类添加一个 originalSelector 方法
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        //添加方法成功, 那么互换 viewWillAppear 和 fd_viewWillAppear方法
        if (success)
        {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else //添加失败,则直接交换方法实现
        {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (void)fd_viewWillAppear:(BOOL)animated
{
    
    [self fd_viewWillAppear:animated];
    
    if (self.fd_willAppearInjectBlock)
    {
        self.fd_willAppearInjectBlock(self, animated);
    }
}


//分类中不能为@property 关键字生成带下划线的实例变量,所以要手动实现 set get 方法;
-(_FDViewControllerWillAppearInjectBlock)fd_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setFd_willAppearInjectBlock:(_FDViewControllerWillAppearInjectBlock)fd_willAppearInjectBlock
{
    //保证set 和 get 方法中关联 key 是同一个
    SEL sel = NSSelectorFromString(@"fd_willAppearInjectBlock");
    objc_setAssociatedObject(self, sel, fd_willAppearInjectBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end







#pragma mark - UINavigationController分类

@implementation UINavigationController (FDFullscreenPopGesture)

//交换pushViewController:animated: 方法为自己的方法
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(fd_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}



//在自己的 push 方法中,在将要被 push 的控制中注入 block 代码
- (void)fd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //处理全局 pop 手势
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fd_fullscreenPopGestureRecognizer])
    {
        //其实就是 [self.view addGestureRecognizer:]
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
        
        //核心代码, 添加全局 pop 手势
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        /*
         其实这个 targtet 就是 pop 手势的代理, 但是最好不要直接去导航控制器的代理,因为你可能不知道在哪里就改了这个手势的代理, 但是通过 KVC 取值的 target 肯定是对的!
        internalTarget == self.interactivePopGestureRecognizer.delegate;
         */
        
        self.fd_fullscreenPopGestureRecognizer.delegate = self.fd_popGestureRecognizerDelegate;
        [self.fd_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //处理导航条的显示和隐藏
    [self fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];


    //防止连续多次 push, 这个是后来别人的 pull request, 为了更完美吧!
    if (![self.viewControllers containsObject:viewController])
    {
        //系统的 push 方法
        [self fd_pushViewController:viewController animated:animated];
    }



}




- (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    //如果不想当前控制器管理导航条的隐藏与否, 那么就不用注入 block 了
    if (!self.fd_viewControllerBasedNavigationBarAppearanceEnabled)return;
    
    //在 push 方法中注入 block, 那么当下一个控制器调用 viewWillAppear 方法的时候,就会调用到我们自己的[fd_viewWillAppear:(BOOL)animated], 然后就会执行 block 的内容,实现自己控制导航条的显示与隐藏;
    __weak typeof (self) weakSelf = self;
    
    _FDViewControllerWillAppearInjectBlock  block = ^(UIViewController *viewController, BOOL animated){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.fd_prefersNavigationBarHidden animated:animated];
        }
    
    };
    appearingViewController.fd_willAppearInjectBlock = block;

    /*
    他这里原文的意思是, 不是每个控制器都是通过 push 方法被加到栈里的, 还有可能是 -setViewControllers:
     那么就要把上个将要消失的界面也注入 block;
    举个例子  你的导航控制器是创建后通过[NaVC setViewControllers:@[firstVC, secondVC]] 设置子控制器;
    那么 secondVC 会出现在栈顶,就是我们一运行程序就看到的那个控制器, 但是如果我们事先在 firstVC中设置了
    self.fd_prefersNavigationBarHidden = YES; 那么我们 pop掉secondVC的时候, firstVC 的导航条实际上是显示的, 只有再次从 firstVC -> secondVC, 那么这个_FDViewControllerWillAppearInjectBlock,才会被注入到 firstVC 中去. 我测试了下,确实是这样,也算是一个bug, 解决方案就是黑魔法替换掉 UINavigationController 的 setViewControllers方法; 在替换的方法中遍历导航控制器的子控制器 一一注入 block;
    */
    
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.fd_willAppearInjectBlock) {
        disappearingViewController.fd_willAppearInjectBlock = block;
    }
}


// 这个属性没有声明, 只是实现了 get 方法,因为是私有的,所以 set 方法也直接写在里面
// 把手势的代理独立出去交给一个类管理
-(_FDFullscreenPopGestureRecognizerDelegate *)fd_popGestureRecognizerDelegate
{

    _FDFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate)
    {
        delegate = [[_FDFullscreenPopGestureRecognizerDelegate alloc]init];
        delegate.navigationController = self;
    
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}


///实现 set get 方法
- (BOOL)fd_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setFd_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(fd_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)fd_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}





@end
