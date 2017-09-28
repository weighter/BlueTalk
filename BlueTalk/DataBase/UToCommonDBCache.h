//
//  UToCommonDBCache.h
//  UtoPassenger
//
//  Created by tomodel on 2017/6/19.
//  Copyright © 2017年 uto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabasePool.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "UToNSFileManager.h"
#import "UToCommonDBCacheHeader.h"
#import "UToSingleton.h"
#import "UToChatItem.h"

@interface UToCommonDBCache : NSObject {

    FMDatabaseQueue *_dbQueue;  // 这个类在多个线程来执行查询和更新时会使用这个类。避免同时访问同一个数据。
    FMDatabasePool *_dbPool;    // 数据库连接池 减少连接开销（这要明确知道不会同一时刻有多个线程去操作数据库，如果会就是用FMDatabaseQueue）
}

single_interface(UToCommonDBCache)

// 创建表
- (void)createTable;

- (NSMutableArray *)getHistoryMessage:(NSString *)key value:(id)value;

#pragma mark - 增
- (void)addHistoryMessage:(UToChatItem *)item;

- (void)updataHistoryMessage:(UToChatItem *)item;

@end
