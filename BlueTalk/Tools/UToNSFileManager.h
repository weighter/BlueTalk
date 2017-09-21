//
//  UToSXNSFileManager.h
//  UtoPassenger
//
//  Created by wufeng on 16/3/21.
//  Copyright © 2016年 uto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UToNSFileManager : NSObject

// 读取Document目录
+ (NSString *)getAppDocumentPath;

// 读取Document目录中用户名下目录 （用于存放私有数据库文件、配置文件、.text等文件）
+ (NSString *)getAppDocumentPathEx;

// 读取Document目录下公共目录 （用于公共拥有的数据如：缓存数据等信息）
+ (NSString *)getAppDocumentPublicPath;

// 读取Chache目录
+ (NSString *)getAppCachePath;

// 读取Chache目录中用户名下目录 （用于存放用户私有的数据信息如：图片、语音、xml文件等）
+ (NSString *)getAppCachePathEx;

// 读取Chache目录下公共目录 （用于公共拥有的数据）
+ (NSString *)getAppCachePublicPath;

// 读取tmp目录
+ (NSString *)getAppTmpPath;

@end
