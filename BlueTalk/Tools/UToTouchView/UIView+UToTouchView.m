//
//  UIView+UToTouchView.m
//  tb
//
//  Created by Weighter on 2017/4/20.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UIView+UToTouchView.h"

@implementation UIView (UToTouchView)

#pragma mark - TAP
- (void)addTapTouchTarget:(id)target action:(SEL)action {
    
    [self addTapTouchTarget:target action:action numberOfTapsRequired:1 numberOfTouchesRequired:1];
}

- (void)addTapTouchTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)taps numberOfTouchesRequired:(NSUInteger)touches {
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    _tap.numberOfTapsRequired = taps;
    _tap.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:_tap];
}

- (void)removeTapTouchTarget:(id)target action:(SEL)action {
    
//    [self removeGestureRecognizer:self.gestureRecognizers];
}

#pragma mark - PINCH
- (void)addPinchTouchTarget:(id)target action:(SEL)action {
    
    self.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *_pin = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:_pin];
}

#pragma mark - PAN
- (void)addPanTouchTarget:(id)target action:(SEL)action {
    
    [self addPanTouchTarget:target action:action minimumNumberOfTouches:1 maximumNumberOfTouches:UINT_MAX];
}

- (void)addPanTouchTarget:(id)target action:(SEL)action minimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches maximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches {
    
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *_pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    _pan.minimumNumberOfTouches = minimumNumberOfTouches;
    _pan.maximumNumberOfTouches = maximumNumberOfTouches;
    [self addGestureRecognizer:_pan];
}

#pragma mark - SWIPE
- (void)addSwipeTouchTarget:(id)target action:(SEL)action {
    
    [self addSwipeTouchTarget:target action:action direction:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown];
}

- (void)addSwipeTouchTarget:(id)target action:(SEL)action direction:(UISwipeGestureRecognizerDirection)direction {
    
    [self addSwipeTouchTarget:target action:action direction:direction numberOfTouchesRequired:1];
}

- (void)addSwipeTouchTarget:(id)target action:(SEL)action direction:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired {
    
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *_swi = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    _swi.direction = direction;
    _swi.numberOfTouchesRequired = numberOfTouchesRequired;
    [self addGestureRecognizer:_swi];
}

#pragma mark - ROTATION
- (void)addRotationTouchTarget:(id)target action:(SEL)action {
    
    UIRotationGestureRecognizer *_rot = [[UIRotationGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:_rot];
}

#pragma mark - LONG PRESS
- (void)addLongPressTouchTarget:(id)target action:(SEL)action {
    
    [self addLongPressTouchTarget:target action:action numberOfTapsRequired:0 numberOfTouchesRequired:1 minimumPressDuration:0.5 allowableMovement:10];
}

- (void)addLongPressTouchTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired minimumPressDuration:(CFTimeInterval)minimumPressDuration allowableMovement:(CGFloat)allowableMovement {
    
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *_lp = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    _lp.numberOfTapsRequired = numberOfTapsRequired;
    _lp.numberOfTouchesRequired = numberOfTouchesRequired;
    _lp.minimumPressDuration = minimumPressDuration;
    _lp.allowableMovement = allowableMovement;
    [self addGestureRecognizer:_lp];
}

#pragma mark - RemoveAllGes
- (void)removeAllGestureRecognizer {
    
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        
        [self removeGestureRecognizer:ges];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self endEditing:YES];
}

@end
