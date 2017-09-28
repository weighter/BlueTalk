//
//  UIView+UToTouchView.h
//  tb
//
//  Created by Weighter on 2017/4/20.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UToTouchView)

- (void)addTapTouchTarget:(id)target action:(SEL)action;

- (void)addTapTouchTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)taps numberOfTouchesRequired:(NSUInteger)touches;

- (void)addPinchTouchTarget:(id)target action:(SEL)action;

- (void)addPanTouchTarget:(id)target action:(SEL)action;

- (void)addPanTouchTarget:(id)target action:(SEL)action minimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches maximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches;

- (void)addSwipeTouchTarget:(id)target action:(SEL)action;

- (void)addSwipeTouchTarget:(id)target action:(SEL)action direction:(UISwipeGestureRecognizerDirection)direction;

- (void)addSwipeTouchTarget:(id)target action:(SEL)action direction:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired;

- (void)addRotationTouchTarget:(id)target action:(SEL)action;

- (void)addLongPressTouchTarget:(id)target action:(SEL)action;

- (void)addLongPressTouchTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired minimumPressDuration:(CFTimeInterval)minimumPressDuration allowableMovement:(CGFloat)allowableMovement;

- (void)removeAllGestureRecognizer;

@end
