//
//  AppDelegate.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "AppDelegate.h"
#import "UToMsgViewController.h"
#import "UToLinkmanViewController.h"
#import "UToMeViewController.h"
#import "UToBlueSessionManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UToMsgViewController *mvc = [[UToMsgViewController alloc] init];
    mvc.title = @"消息";
    UINavigationController *mNav = [[UINavigationController alloc] initWithRootViewController:mvc];
    
    UToLinkmanViewController *lvc = [[UToLinkmanViewController alloc] init];
    lvc.title = @"联系人";
    UINavigationController *lNav = [[UINavigationController alloc] initWithRootViewController:lvc];
    
    UToMeViewController *mevc = [[UToMeViewController alloc] init];
    mevc.title = @"我";
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:mevc];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[mNav, lNav, meNav];
    self.window.rootViewController= tabBarController;
    
    // 初始化  会议室
    [get_singleton_for_class(UToBlueSessionManager) setDisplayName:[NSString stringWithFormat:@" %@",  [[UIDevice currentDevice] name]]];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
