//
//  ChatItem.h
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    textStates,
    picStates,
    videoStates,
    
}newsStates;

@interface ChatItem : NSObject

@property (nonatomic, assign) BOOL isSelf;//
@property (nonatomic, assign) newsStates states;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIImage *picImage;
@property (nonatomic, strong) NSData *recordData;

@end
