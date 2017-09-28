//
//  UToChatItem.h
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    textStates,
    picStates,
    voiceStates,
    videoStates,
    
} newsStates;

@interface UToChatItem : NSObject

@property (nonatomic, assign) BOOL isSelf; // 判断是接受，还是发的
@property (nonatomic, assign) newsStates states;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, strong) NSData *data; // 数据内容
@property (nonatomic, assign) NSTimeInterval time;

@end
