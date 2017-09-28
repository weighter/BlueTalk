//
//  NSObject+UToGetCurrentViewController.m
//  UtoPassenger
//
//  Created by Weighter on 2017/8/23.
//  Copyright © 2017年 uto. All rights reserved.
//

#import "NSObject+UToGetCurrentViewController.h"

@implementation NSObject (UToGetCurrentViewController)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController {
    
    UIViewController *result = nil;
    UIWindow *normalWindow = nil;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows) {
        
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            
            normalWindow = window;
            break;
        }
    }
    
    NSArray *views = normalWindow.subviews;
    if (views.count>0) {
        
        UIView *frontView = [[normalWindow subviews] objectAtIndex:0];
        
        for (UIView *next = [frontView superview]; next; next = next.superview) {
            
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                
                result = (UIViewController*)nextResponder;
                break;
            }
        }
    }
    
    if (result == nil) {
        
        result = normalWindow.rootViewController;
    }
    
    return result;
}

@end
