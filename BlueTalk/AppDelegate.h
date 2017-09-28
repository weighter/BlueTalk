//
//  AppDelegate.h
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UToChatItem.h"
#import "UToMessageUpdateDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

extern AppDelegate *utoDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) id<UToMessageUpdateDelegate> rdelegate;

@end

