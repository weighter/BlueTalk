//
//  UToCommonDBCache.m
//  UtoPassenger
//
//  Created by tomodel on 2017/6/19.
//  Copyright © 2017年 uto. All rights reserved.
//

#import "UToCommonDBCache.h"
#import "MJExtension.h"

@implementation UToCommonDBCache

single_implementation(UToCommonDBCache)

//NSString *GetHistoryCityType(UToHistoryCityType status) {
//    switch (status) {
//        case UToHistoryCityTypeTrain:
//            return @"train";
//        case UToHistoryCityTypeTicket:
//            return @"ticket";
//        default:
//            return @"";
//    }
//}

// 创建数据库
- (void)createTable {
    
    // 获取数据库地址
    NSString* path = [UToNSFileManager getAppDocumentPublicPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { // 如果不存在直接创建
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *DBPath = [NSString stringWithFormat:@"%@/%@",path,DB_COMMON_NAME];
    _dbQueue = [[FMDatabaseQueue alloc] initWithPath:DBPath];
    _dbPool = [[FMDatabasePool alloc] initWithPath:DBPath];
    [self createAllTables];
}

// 创建数据表
- (void)createAllTables {
    
    [self createHistoryMessageTable];
}

#pragma mark --
#pragma mark -- 消息表 相关操作
// 创建消息表
- (void)createHistoryMessageTable {
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        
        if ([db tableExists:TableHistoryMessage]) {
            
        } else {
            
            NSString *sql = [NSString stringWithFormat:
                             @"CREATE TABLE IF NOT EXISTS %@ ( "
                             "%@ TEXT, "
                             "%@ TEXT, "
                             "%@ INTEGER, "
                             "%@ INTEGER"
                             " ); ",
                             TableHistoryMessage,
                             MessageDisplayName,
                             MessageData,
                             MessageStates,
                             MessageTime
                             ];
            NSLog(@"%@",sql);
            BOOL result = [db executeUpdate:sql];
            
            if (result) {
                
                NSLog(@"create t_history_message success");
            } else {
                
                NSLog(@"create t_history_message failed");
            }
        }
    }];
}

- (NSMutableArray *)getHistoryMessage:(NSString *)displayName {
    
    __block NSMutableArray *streetEntityArray = [[NSMutableArray alloc]init];
    
    [_dbPool inDatabase:^(FMDatabase *db) {
        
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ORDER BY %@ DESC;", TableHistoryMessage, MessageDisplayName, MessageTime];
        FMResultSet *resultSet = [db executeQuery:selectSql,displayName];
        
        while ([resultSet next]) {
            
            NSDictionary *bb = [resultSet resultDictionary];
            NSLog(@"BB = %@",bb);
            UToChatItem *street = [UToChatItem mj_objectWithKeyValues:bb];
            [streetEntityArray addObject:street];
        }
        [resultSet close];
    }];
    return streetEntityArray;
}

- (void)updataHistoryMessage:(UToChatItem *)item {
    
    __block BOOL whoopsSomethingWrongHappened = true;
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = ? ;", TableHistoryMessage, MessageDisplayName];
        whoopsSomethingWrongHappened = [db executeUpdate:deleteSql,item.displayName];
        
        if (!whoopsSomethingWrongHappened) {
            
            NSLog(@"delete t_history_street failed");
        }
        
        NSMutableArray *chatItems = [NSMutableArray array];
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ;",TableHistoryMessage,MessageDisplayName];
        FMResultSet *resultSet = [db executeQuery:selectSql,item.displayName];
        
        while ([resultSet next]) {
            
            NSDictionary *bb = [resultSet resultDictionary];
            NSLog(@"BB = %@",bb);
            UToChatItem *chatItem = [UToChatItem mj_objectWithKeyValues:bb];
            [chatItems addObject:chatItem];
        }
        
        NSInteger b = chatItems.count;
        
        while (b > 4) {
            
            UToChatItem *itemLast =[chatItems firstObject];
            NSString *deleteLastSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = ? ;",TableHistoryMessage,MessageDisplayName];
            whoopsSomethingWrongHappened = [db executeUpdate:deleteLastSql,itemLast.displayName];
            
            if (!whoopsSomethingWrongHappened) {
                
                NSLog(@"delete t_history_street failed");
                *rollback = YES;
                return;
            }
            b--;
        }
        
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@, "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?,?,?,?,?); ",
                               TableHistoryMessage,
                               MessageDisplayName,
                               MessageData,
                               MessageStates,
                               MessageTime
                               ];
        
        NSDate *date = [NSDate date];
        UInt64 datetime = [date timeIntervalSince1970];
        
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        item.displayName,
                                        item.recordData,
                                        item.states,
                                        [NSNumber numberWithLongLong:datetime]
                                        ];
        
        if (whoopsSomethingWrongHappened) {
            
            NSLog(@"save t_history_message success");
        } else {
            
            NSLog(@"save t_history_message failed");
            *rollback = YES;
            return;
        }
    }];
}


@end
