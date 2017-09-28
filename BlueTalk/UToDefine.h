//
//  UToDefine.h
//  UtoPassenger
//
//  Created by wufeng on 15/8/26.
//  Copyright (c) 2015年 uto. All rights reserved.
//

#import "MBProgressHUD.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIView+UToView.h"
#import "UToAlert.h"
#import "UIView+MBProgressHUD.h"
#import "UIView+UToTouchView.h"

#define StrSame(i,v)                    [i isEqualToString:v]
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
#define NAV_BAR_HEIGHT                  44.0f
#define STATUS_BAR_HEIGHT               20.0f
#define TopMargin                       5.f
#define LeftMargin                      15.f
#define BottomMargin                    5.f
#define RightMargin                     15.f
#define PixelSpacing                    10.f
#define CornerRadius                    10.f
#define COLOR(r,g,b)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define COLORA(r,g,b,a)                 [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(h)                     [UToColor colorWithHexString:h]
#define HEXCOLOR2(h,a)                  [UToColor colorWithHexString:h alpha:a]

#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kBaseLine(a) (CGFloat)a * SCREEN_WIDTH / 375.0
#define kMarge 15.f

// 系统宏定义
#define ISIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define ISIOS8 [[UIDevice currentDevice].systemVersion floatValue]>=8
#define ISIOS9 [[UIDevice currentDevice].systemVersion floatValue]>=9
#define ISIOS10 [[UIDevice currentDevice].systemVersion floatValue]>=10
// 设备宏定义
// 判断是否为 iPhone 4s
#define IPHONE4 ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f)

// 判断是否为 iPhone 5SE
#define IPHONE5 ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f)

// 判断是否为iPhone 6/6s
#define IPHONE6 ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f)

// 判断是否为iPhone 6Plus/6sPlus
#define IPHONE6PLUS ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f)


#define LocationCoorKey @"LocationCoorKey"

#pragma mark 用于手动释放对象
#define BEGIN_AUTORELEASE		@autoreleasepool{
#define END_AUTORELEASE			}


#define kNSStringWithString(str)    [NSString stringWithString:(str?str:@"")]

#define WEAKSELF typeof(self) __weak weakSelf = self;

#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
