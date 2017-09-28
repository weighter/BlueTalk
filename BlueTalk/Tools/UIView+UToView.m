//
//  UIView+UToView.m
//  BlueTalk
//
//  Created by Weighter on 2017/9/22.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UIView+UToView.h"

@implementation UIView (UToView)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

@end
