//
//  UIView+MBProgressHUD.h
//  UToHitchhike
//
//  Created by Weighter on 2016/12/2.
//  Copyright © 2016年 uto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (MBProgressHUD)

/**
 显示HUD成功提示语
 
 message 提示语
 code    服务器返回code
 */
- (void)showHudSuccessMsg:(NSString *)successMsg;

/**
 提示网络错误
 */
- (void)showHudNetworkError;

/**
 显示HUD错误提示语
 
 errorMsg 错误提示语
 */
- (void)showHudErrorMsg:(NSString *)errorMsg;

/**
 显示HUD加载数据提示语
 
 text 提示语
 
 @return MBProgressHUD
 */
- (MBProgressHUD *)showHudLoadText:(NSString *)text;

/**
 显示HUD提示语
 
 text 提示语
 
 @return MBProgressHUD
 */
- (MBProgressHUD *)showHudPureText:(NSString *)text;

/**
 显示HUD提示语
 
 text 提示语
 mode MBProgressHUDMode
 
 @return MBProgressHUD
 */
- (MBProgressHUD *)showHudText:(NSString *)text mode:(MBProgressHUDMode)mode;

/**
 显示HUD提示语
 
 view       HUD要显示在view上
 mode       MBProgressHUDMode
 text       提示语
 name       图片名称
 completion MBProgressHUDCompletionBlock
 
 @return MBProgressHUD
 */
- (MBProgressHUD *)showHudInView:(UIView *)view mode:(MBProgressHUDMode)mode text:(NSString *)text image:(UIImage *)image completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 显示HUD之后隐藏
 
 text      提示语
 animation 是否有动画
 delay     延迟隐藏
 */
- (void)showHudPureText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay;

/**
 显示HUD之后隐藏
 
 text       提示语
 animation  是否有动画
 delay      延迟隐藏
 completion MBProgressHUDCompletionBlock
 */
- (void)showHudPureText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 显示HUD之后隐藏
 
 text      提示语
 animation 是否有动画
 delay     延迟隐藏
 */
- (void)showHudLoadText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay;

/**
 显示HUD之后隐藏
 
 text       提示语
 animation  是否有动画
 delay      延迟隐藏
 completion MBProgressHUDCompletionBlock
 */
- (void)showHudLoadText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 显示HUD之后隐藏
 
 text       提示语
 mode       MBProgressHUDMode
 animation  是否有动画
 delay      延迟隐藏
 completion MBProgressHUDCompletionBlock
 */
- (void)showHudText:(NSString *)text image:(UIImage *)image mode:(MBProgressHUDMode)mode hideAnimation:(BOOL)animation after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 显示GIFHUD提示语

 gifname GIF图片名
 text 提示语
 @return GIFHUD
 */
- (MBProgressHUD *)showGIFHud:(NSString *)gifname text:(NSString *)text;

/**
 显示GIFHUD提示语

 view HUD要显示在view上
 gifname GIF图片名
 text 提示语
 animated 是否有动画
 @return GIFHUD
 */
- (MBProgressHUD *)showGIFHudInView:(UIView *)view gifname:(NSString *)gifname text:(NSString *)text completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 隐藏HUD
 
 animation 是否有动画
 */
- (void)hideHudAnimation:(BOOL)animation;

/**
 隐藏HUD
 
 animation 是否有动画
 delay     延迟隐藏
 */
- (void)hideHudAnimation:(BOOL)animation after:(NSTimeInterval)delay;

@end
