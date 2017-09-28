//
//  UIView+MBProgressHUDS.m
//  UToHitchhike
//
//  Created by Weighter on 2016/12/2.
//  Copyright © 2016年 uto. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import "UIImage+Gif.h"

@implementation UIView (MBProgressHUD)

- (void)showHudSuccessMsg:(NSString *)successMsg {
    
    [self showHudText:successMsg image:[UIImage imageNamed:@"success"] mode:MBProgressHUDModeCustomView hideAnimation:YES after:1.0f completionBlock:nil];
}

- (void)showHudNetworkError {
    
    [self showHudErrorMsg:@"网络异常,请重新尝试"];
}

- (void)showHudErrorMsg:(NSString *)errorMsg {
    
    [self showHudText:errorMsg image:[UIImage imageNamed:@"networkError"] mode:MBProgressHUDModeCustomView hideAnimation:YES after:1.0f completionBlock:nil];
}

- (void)showHudPureText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay {
    
    [self showHudPureText:text hideAnimation:animation after:delay completionBlock:nil];
}

- (void)showHudPureText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion {
    
    [self showHudText:text image:nil mode:MBProgressHUDModeText hideAnimation:animation after:delay completionBlock:completion];
}

- (void)showHudLoadText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay {
    
    [self showHudLoadText:text hideAnimation:animation after:delay completionBlock:nil];
}

- (void)showHudLoadText:(NSString *)text hideAnimation:(BOOL)animation after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion {
    
    [self showHudText:text image:nil mode:MBProgressHUDModeIndeterminate hideAnimation:animation after:delay completionBlock:completion];
}

- (void)showHudText:(NSString *)text image:(UIImage *)image mode:(MBProgressHUDMode)mode hideAnimation:(BOOL)animation after:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)completion {
    
    [self showHudInView:self mode:mode text:text image:image completionBlock:completion];
    [self hideHudAnimation:animation after:delay];
}

- (MBProgressHUD *)showHudLoadText:(NSString *)text {
    
    return [self showHudText:text mode:MBProgressHUDModeIndeterminate];
}

- (MBProgressHUD *)showHudPureText:(NSString *)text {
    
    return [self showHudText:text mode:MBProgressHUDModeText];
}

- (MBProgressHUD *)showHudText:(NSString *)text mode:(MBProgressHUDMode)mode {
    
    return [self showHudInView:self mode:mode text:text image:nil completionBlock:nil];
}

- (MBProgressHUD *)showGIFHud:(NSString *)gifname text:(NSString *)text {
    
    return [self showGIFHudInView:self gifname:gifname text:text completionBlock:nil];
}

- (MBProgressHUD *)showGIFHudInView:(UIView *)view gifname:(NSString *)gifname text:(NSString *)text completionBlock:(MBProgressHUDCompletionBlock)completion {
    
    if (!gifname) {
        
        gifname = @"load_img";
    }
    MBProgressHUD *hud = [self showHudInView:self mode:MBProgressHUDModeCustomView text:text image:[UIImage sd_animatedGIFNamed:gifname] completionBlock:completion];
    hud.backgroundColor = [UIColor clearColor];
    hud.userInteractionEnabled = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundView.color = [UIColor clearColor];
    hud.backgroundView.backgroundColor = [UIColor clearColor];
    hud.backgroundColor = [UIColor clearColor];
    hud.label.textColor = [UIColor blackColor];
    return hud;
}

- (MBProgressHUD *)showHudInView:(UIView *)view mode:(MBProgressHUDMode)mode text:(NSString *)text image:(UIImage *)image completionBlock:(MBProgressHUDCompletionBlock)completion {
    
    UIView *backView = view;
    if (backView == nil || ![backView isKindOfClass:[UIView class]]) {
        
        backView = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *_hud = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
    NSArray *hudArray = [MBProgressHUD allHUDsForView:backView];
#pragma clang diagnostic pop
    for (MBProgressHUD *hud in hudArray) {
        if (hud.tag == 999999999) {
            
            _hud = hud;
        } else {
            
            [hud hideAnimated:YES];
        }
    }
    
    if (!_hud) {
        
        _hud = [MBProgressHUD showHUDAddedTo:backView animated:YES];
        _hud.tag = 999999999;
    }
    
    [_hud showAnimated:YES];
    _hud.mode = mode;
    _hud.completionBlock = completion;
    
    if (mode == MBProgressHUDModeCustomView) {
        
        _hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    
    _hud.label.text = text;
    return _hud;
}

- (void)hideHudAnimation:(BOOL)animation {
    
    [self hideHudAnimation:animation after:0.0];
}

- (void)hideHudAnimation:(BOOL)animation after:(NSTimeInterval)delay {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
    NSArray *hudArray = [MBProgressHUD allHUDsForView:self];
#pragma clang diagnostic pop
    for (MBProgressHUD *hud in hudArray) {
        if (hud.tag == 999999999) {
            
            [hud hideAnimated:animation afterDelay:delay];
        } else {
            
            [hud hideAnimated:YES];
        }
    }
}

@end
