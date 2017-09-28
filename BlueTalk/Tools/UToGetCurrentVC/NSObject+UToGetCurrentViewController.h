//
//  NSObject+UToGetCurrentViewController.h
//  UtoPassenger
//
//  Created by Weighter on 2017/8/23.
//  Copyright © 2017年 uto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UToGetCurrentViewController)

/**
 获取当前屏幕显示的viewcontroller

 @return 当前屏幕显示的viewcontroller
 */
+ (UIViewController *)getCurrentViewController;

@end
