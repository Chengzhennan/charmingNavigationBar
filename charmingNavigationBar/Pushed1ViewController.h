//
//  Pushed1ViewController.h
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BackType) {
    BackTypeBackItem = 1,
    BackTypeLeftItem
};


@interface Pushed1ViewController : UIViewController


@property (nonatomic,assign)BackType backType;


@end
