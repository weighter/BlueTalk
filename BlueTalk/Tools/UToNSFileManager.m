//
//  UToNSFileManager.m
//
//
//  Created by wufeng on 16/3/21.
//  Copyright © 2016年 UTo. All rights reserved.
//

#import "UToNSFileManager.h"

@implementation UToNSFileManager

// 读取Document目录
+ (NSString *)getAppDocumentPath {
    
    NSArray* lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* result = nil;
    
    if([lpPaths count]>0) {
        
        result = [NSString stringWithFormat:@"%@",[lpPaths objectAtIndex:0]];
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}

// 读取Document目录中用户名下目录 （用于存放私有数据库文件、配置文件、.text等文件）
+ (NSString *)getAppDocumentPathEx {
    
    NSArray *lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *result = nil;
    
    if([lpPaths count]>0) {
        
        if ([[UIDevice currentDevice] name]) {
            
            result = [NSString stringWithFormat:@"%@/%@",[lpPaths objectAtIndex:0],[[UIDevice currentDevice] name]];
        } else {
            
            result = [NSString stringWithFormat:@"%@/Guest",[lpPaths objectAtIndex:0]];
        }
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}

// 读取Document目录下公共目录 （用于公共拥有的数据如：缓存数据等信息）
+ (NSString *)getAppDocumentPublicPath {

    NSArray* lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* result = nil;
    
    if([lpPaths count]>0) {
        
        result = [NSString stringWithFormat:@"%@/Public",[lpPaths objectAtIndex:0]];
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}

// 读取Chache目录
+ (NSString *)getAppCachePath {

    NSArray* lpPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* result = nil;
    
    if([lpPaths count]>0) {
        
        result = [NSString stringWithFormat:@"%@",[lpPaths objectAtIndex:0]];
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}

// 读取Chache目录中用户名下目录 （用于存放用户私有的数据信息如：图片、语音、xml文件等）
+ (NSString *)getAppCachePathEx {

    NSArray* lpPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* result = nil;
    
    if([lpPaths count]>0) {
        
        if ([[UIDevice currentDevice] name]) {
            
            result = [NSString stringWithFormat:@"%@/%@",[lpPaths objectAtIndex:0],[[UIDevice currentDevice] name]];
        } else {
            
            result = [NSString stringWithFormat:@"%@/Guest",[lpPaths objectAtIndex:0]];
        }
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}

// 读取Chache目录下公共目录 （用于公共拥有的数据）
+ (NSString *)getAppCachePublicPath {

    NSArray* lpPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* result = nil;
    
    if([lpPaths count]>0) {
        
        result = [NSString stringWithFormat:@"%@/Public",[lpPaths objectAtIndex:0]];
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}

//读取tmp目录
+ (NSString *)getAppTmpPath {
    
    NSString *tmpDir =  NSTemporaryDirectory();
    return tmpDir;
}

@end
