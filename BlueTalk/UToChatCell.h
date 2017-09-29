//
//  UToChatCell.h
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UToChatItem.h"

#define MessageLabelFont [UIFont systemFontOfSize:14]

typedef void(^PlayTheRecordAudio)(BOOL startPlay);

@interface UToChatCell : UITableViewCell

@property (nonatomic, strong) UIView *leftGroundView;
@property (nonatomic, strong) UIView *rightGroundView;
@property (nonatomic, strong) UIImageView *leftHeadImage;
@property (nonatomic, strong) UIImageView *rightHeadImage;
@property (nonatomic, strong) UIImageView *leftBackImageView;
@property (nonatomic, strong) UIImageView *rightBackImageView;
@property (nonatomic, strong) UIImageView *leftPicImageView;
@property (nonatomic, strong) UIImageView *rightPicImageView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UToChatItem *chatItem;
@property (nonatomic, copy) PlayTheRecordAudio block;

- (void)setBlock:(PlayTheRecordAudio)block;

- (void)showViewIsSelf:(BOOL)isSelf;

- (void)endPlaying;

@end
