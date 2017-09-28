//
//  UToChatItem.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToChatItem.h"
#import "utoCommonDBCacheHeader.h"

@implementation UToChatItem

// 此处添加的原因 是iphone 6 和  iphone 5的区别，暂时具体原因不知道
@synthesize data = _data;
- (void)setData:(NSData *)data {
    
    _data = data;
}

- (NSData *)data {
    
    return _data;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"displayName":@[MessageDisplayName, @"displayName"],
             @"data":@[MessageData, @"data"],
             @"time":@[MessageTime, @"time"],
             @"states":@[MessageStates, @"states"],
             @"isSelf":@[MessageIsSelf, @"isSelf"]};
}

@end
