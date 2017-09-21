//
//  UToSingleton.h
//  UtoPassenger
//
//  Created by Weighter on 2017/9/20.
//  Copyright © 2017年 Weighter. All rights reserved.
//
//  单例类宏定义

// .h    定义宏
#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏   实现宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

#define get_singleton_for_class(classname) \
[classname shared##classname]

