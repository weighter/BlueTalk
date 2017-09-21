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
@synthesize recordData = _recordData;
- (void)setRecordData:(NSData *)recordData
{
    _recordData = recordData;
}


- (NSData *)recordData
{
    return _recordData;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"displayName":@[MessageDisplayName,@"displayName"],@"recordData":@[MessageData,@"recordData"],@"content":@[MessageContent,@"content"],@"picImage":@[@"picImage"],@"states":@[MessageStates,@"states"]};
}

@end
