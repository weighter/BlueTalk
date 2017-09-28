//
//  UToAlert.m
//  tb
//
//  Created by Weighter on 2017/2/15.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToAlert.h"

NSString * const UToalertTitleKey = @"UToalertTitleKey";
NSString * const UToalertContentKey = @"UToalertContentKey";
NSString * const UToalertcancelKey = @"UToalertcancelKey";
NSString * const UToalertokKey = @"UToalertokKey";
NSString * const UToselectKey = @"UToselectKey";

@interface UToAlert()

@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, assign) BOOL showing;
@property (nonatomic, strong) id alert;
@property (nonatomic, assign) UToAlertStyle style;                              // 类型

@end

@implementation UToAlert

+ (instancetype)AlertSheetTitle:(NSString *)title content:(NSString *)content cancelButton:(NSString *)canceltitle selectButton:(NSArray<NSString *> *)selectButton complete:(UToSheetCompleteBlock)block {
    
    UToAlert *al = [[UToAlert alloc] init];
    al.block = block;
    al.style = UToAlertStyleActionSheet;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (title) {
        
        [dic setValue:title forKey:UToalertTitleKey];
    }
    
    if (content) {
        
        [dic setValue:content forKey:UToalertContentKey];
    }
    
    if (canceltitle) {
        
        [dic setValue:canceltitle forKey:UToalertcancelKey];
    }
    
    if (selectButton) {
        
        [dic setValue:selectButton forKey:UToselectKey];
    }
    
    if (dic.count > 0) {
        
        al.infoDic = [dic copy];
    }
    
    return al;
}

+ (instancetype)AlertTitle:(NSString *)title content:(NSString *)content cancelButton:(NSString *)canceltitle okButton:(NSString *)oktitle complete:(UToAlertCompleteBlock)block {
    
    UToAlert *al = [[UToAlert alloc] init];
    al.completeBlock = block;
    al.style = UToAlertStyleAlert;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (title) {
        
        [dic setValue:title forKey:UToalertTitleKey];
    }
    
    if (content) {
        
        [dic setValue:content forKey:UToalertContentKey];
    }
    
    if (canceltitle) {
        
        [dic setValue:canceltitle forKey:UToalertcancelKey];
    }
    
    if (oktitle) {
        
        [dic setValue:oktitle forKey:UToalertokKey];
    }
    
    if (dic.count > 0) {
        
        al.infoDic = [dic copy];
    }
    
    return al;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if (self.completeBlock) {
            
            self.completeBlock(YES);
        }
    }
    _showing = NO;
}

- (UIAlertView *)alertView {
    
    UIAlertView *av = nil;
    if (self.infoDic.count > 0) {
        
        av = [[UIAlertView alloc] initWithTitle:_infoDic[UToalertTitleKey] message:_infoDic[UToalertContentKey] delegate:self cancelButtonTitle:_infoDic[UToalertcancelKey] otherButtonTitles:_infoDic[UToalertokKey], nil];
    }
    return av;
}

- (UIActionSheet *)actionSheet {
    
    UIActionSheet *as = nil;
    if (self.infoDic.count > 0) {
        
        as = [[UIActionSheet alloc] initWithTitle:_infoDic[UToalertTitleKey] delegate:self cancelButtonTitle:_infoDic[UToalertcancelKey] destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        NSArray *select = _infoDic[UToselectKey];
        if ([select isKindOfClass:[NSArray class]]) {
            
            for (NSString *selectTitle in select) {
                
                [as addButtonWithTitle:selectTitle];
            }
        }
    }
    return as;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.block) {
        
        self.block(buttonIndex);
    }
    _showing = NO;
}

- (UIAlertController *)alertController {
    
    UIAlertController *ac = nil;
    if (self.infoDic.count > 0) {
        
        if (_style == UToAlertStyleAlert) {
            
            ac = [UIAlertController alertControllerWithTitle:_infoDic[UToalertTitleKey] message:_infoDic[UToalertContentKey] preferredStyle:UIAlertControllerStyleAlert];
            
            NSString *canceltitle = _infoDic[UToalertcancelKey];
            __typeof(self) __weak wself = self;
            if (canceltitle) {
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:canceltitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (wself.completeBlock) {
                        
                        wself.completeBlock(NO);
                    }
                    
                    wself.showing = NO;
                }];
                [ac addAction:cancelAction];
            }
            
            NSString *oktitle = _infoDic[UToalertokKey];
            if (oktitle) {
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:oktitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (wself.completeBlock) {
                        
                        wself.completeBlock(YES);
                    }
                    wself.showing = NO;
                }];
                [ac addAction:okAction];
            }
        } else if (_style == UToAlertStyleActionSheet) {
            
            ac = [UIAlertController alertControllerWithTitle:_infoDic[UToalertTitleKey] message:_infoDic[UToalertContentKey] preferredStyle:UIAlertControllerStyleActionSheet];
            
            NSString *canceltitle = _infoDic[UToalertcancelKey];
            __typeof(self) __weak wself = self;
            if (canceltitle) {
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:canceltitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (wself.block) {
                        
                        wself.block(0);
                    }
                    
                    wself.showing = NO;
                }];
                [ac addAction:cancelAction];
            }
            
            NSArray *selectBtn = _infoDic[UToselectKey];
            if ([selectBtn isKindOfClass:[NSArray class]]) {
                
                for (NSInteger i = 0; i < selectBtn.count; i++) {
                    
                    NSString *selectTitle = selectBtn[i];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        if (wself.block) {
                            
                            wself.block(i+1);
                        }
                        wself.showing = NO;
                    }];
                    [ac addAction:okAction];
                }
            }
        }
        
    }
    return ac;
}

- (void)showAlertWithController:(UIViewController *)controller {
    
    if (!controller) {
        
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (!(controller.view.window && controller.isViewLoaded)) {
            
            controller = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        }
    }
    
    // iOS8 下需要使用新的 API
    if (ISIOS8) {
        
        UIAlertController *ac = [self alertController];
        _alert = ac;
        [controller presentViewController:ac animated:YES completion:nil];
         _showing = ac != nil;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
        if (_style == UToAlertStyleAlert) {
            
            UIAlertView *av = [self alertView];
            _alert = av;
            [av show];
            _showing = av != nil;
        } else {
            
            UIActionSheet *as = [self actionSheet];
            _alert = as;
            [as showInView:controller.view];
            _showing = as != nil;
        }
#pragma clang diagnostic pop
    }
}

- (void)dismissAlert {
    
    // iOS8 下需要使用新的 API
    if (ISIOS8) {
        
        [_alert dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [_alert dismissWithClickedButtonIndex:MAXFLOAT animated:YES];
    }
    _showing = NO;
}

- (BOOL)isShow {
    
    return _showing;
}

@end
