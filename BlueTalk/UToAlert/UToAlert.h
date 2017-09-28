//
//  UToAlert.h
//  tb
//
//  Created by Weighter on 2017/2/15.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UToAlertCompleteBlock)(BOOL isOk);
typedef void(^UToSheetCompleteBlock)(NSInteger index);

typedef NS_ENUM(NSUInteger, UToAlertStyle) {
    UToAlertStyleAlert = 0,
    UToAlertStyleActionSheet
};

@interface UToAlert : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) UToAlertCompleteBlock completeBlock;    // 点击完成回调
@property (nonatomic, assign) NSInteger tag;                        // 标识
@property (nonatomic, copy) UToSheetCompleteBlock block;            // 点击完成回调

+ (instancetype)AlertSheetTitle:(NSString *)title content:(NSString *)content cancelButton:(NSString *)canceltitle selectButton:(NSArray<NSString *> *)selectButton complete:(UToSheetCompleteBlock)block;

+ (instancetype)AlertTitle:(NSString *)title content:(NSString *)content cancelButton:(NSString *)canceltitle okButton:(NSString *)oktitle complete:(UToAlertCompleteBlock)block;

- (void)showAlertWithController:(UIViewController *)controller;

- (void)dismissAlert;

- (BOOL)isShow;

@end
