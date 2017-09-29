//
//  UToChatCell.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToChatCell.h"

@implementation UToChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIImage *leftImgae = [UIImage imageNamed:@"chat_recive_nor"];
    UIImage *rightImage = [UIImage imageNamed:@"chat_send_nor"];
    
    //这里设定一行一像素 当图片拉伸的时候，只放大两个像素
    leftImgae = [leftImgae stretchableImageWithLeftCapWidth:leftImgae.size.width/2 topCapHeight:leftImgae.size.height/2];
    // 找一行一列的像素
    rightImage = [rightImage stretchableImageWithLeftCapWidth:rightImage.size.width/2 topCapHeight:rightImage.size.height/2];
    // 设定完了后生成了一个新的image;
    
    //----------------------------------------------------------------------------------------//
    // 左边
    if (!_leftGroundView) {
        
        _leftGroundView = [[UIView alloc] init];
        _leftGroundView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_leftGroundView];
    }
    
    if (!_leftHeadImage) {
        
        _leftHeadImage = [[UIImageView alloc] init];
        _leftHeadImage.layer.masksToBounds = YES;
        _leftHeadImage.layer.cornerRadius = 15;
        _leftHeadImage.image = [UIImage imageNamed:@"qq_addfriend_search_friend"];
        [_leftGroundView addSubview:_leftHeadImage];
    }
    
    if (!_leftBackImageView) {
        
        _leftBackImageView = [[UIImageView alloc] init];
        _leftBackImageView.image = leftImgae; // 这里不是一个小像素的图片？？
        _leftBackImageView.userInteractionEnabled = YES;
        [_leftGroundView addSubview:_leftBackImageView];
    }
    
    if (!_leftLabel) {
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = MessageLabelFont;
        _leftLabel.numberOfLines = 0; // 换行
        _leftLabel.backgroundColor = [UIColor clearColor];// 设置透明的
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        [_leftBackImageView addSubview:_leftLabel];
    }
    
    if (!_leftPicImageView) {
        
        _leftPicImageView = [[UIImageView alloc] init];
        _leftPicImageView.layer.cornerRadius = CornerRadius;
        _leftPicImageView.layer.masksToBounds = YES;
        [_leftPicImageView addTapTouchTarget:self action:@selector(leftPicImageViewClicked)];
        [_leftBackImageView addSubview:_leftPicImageView];
    }
    
    //----------------------------------------------------------------------------------------//
    // 右边
    if (!_rightGroundView) {
        
        _rightGroundView = [[UIView alloc] init];
        _rightGroundView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_rightGroundView];
    }
    
    if (!_rightHeadImage) {
        
        _rightHeadImage = [[UIImageView alloc] init];
        _rightHeadImage.layer.masksToBounds = YES;
        _rightHeadImage.layer.cornerRadius = 12;
        _rightHeadImage.image = [UIImage imageNamed:@"qq_addfriend_search_friend"];
        [_rightGroundView addSubview:_rightHeadImage];
    }
    
    if (!_rightBackImageView) {
        
        _rightBackImageView = [[UIImageView alloc] init];
        _rightBackImageView.image = rightImage;
        _rightBackImageView.userInteractionEnabled = YES;
        [_rightGroundView addSubview:_rightBackImageView];
    }
    
    if (!_rightLabel) {
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = MessageLabelFont;
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.numberOfLines = 0;
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        [_rightBackImageView addSubview:_rightLabel];
    }
    
    if (!_rightPicImageView) {
        
        _rightPicImageView = [[UIImageView alloc] init];
        _rightPicImageView.layer.cornerRadius = CornerRadius;
        _rightPicImageView.layer.masksToBounds = YES;
        [_rightPicImageView addTapTouchTarget:self action:@selector(rightPicImageViewClicked)];
        [_rightBackImageView addSubview:_rightPicImageView];
    }
    
    [self positionSubviews];
}

- (void)positionSubviews {
    
    [self.leftGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TopMargin);
        make.left.mas_equalTo(LeftMargin);
        make.bottom.mas_equalTo(-BottomMargin);
        make.right.mas_equalTo(-SCREEN_WIDTH/4);
    }];
    
    [self.leftHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.leftBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(_leftHeadImage.mas_right).offset(PixelSpacing);
        make.right.mas_lessThanOrEqualTo(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PixelSpacing);
        make.left.mas_equalTo(PixelSpacing+LeftMargin);
        make.bottom.mas_equalTo(-PixelSpacing);
        make.right.mas_equalTo(-PixelSpacing-RightMargin);
    }];
    
    [self.leftPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TopMargin+PixelSpacing);
        make.left.mas_equalTo(LeftMargin);
        make.bottom.mas_equalTo(-BottomMargin-PixelSpacing);
        make.right.mas_equalTo(-RightMargin);
    }];
    
    [self.rightGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TopMargin);
        make.left.mas_equalTo(SCREEN_WIDTH/4);
        make.bottom.mas_equalTo(-BottomMargin);
        make.right.mas_equalTo(-RightMargin);
    }];
    
    [self.rightHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];

    [self.rightBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(_rightHeadImage.mas_left).offset(-PixelSpacing);
        make.left.mas_greaterThanOrEqualTo(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PixelSpacing);
        make.left.mas_equalTo(LeftMargin+PixelSpacing);
        make.bottom.mas_equalTo(-PixelSpacing);
        make.right.mas_equalTo(-RightMargin-PixelSpacing);
    }];
    
    [self.rightPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TopMargin+PixelSpacing);
        make.left.mas_equalTo(LeftMargin);
        make.bottom.mas_equalTo(-BottomMargin-PixelSpacing);
        make.right.mas_equalTo(-RightMargin);
    }];
}

- (void)leftPicImageViewClicked {
    
    if (self.chatItem.states == voiceStates) {
        
        if (self.leftPicImageView.isAnimating) {
            
            [self.leftPicImageView stopAnimating];
        } else {
            
            [self.leftPicImageView startAnimating];
        }
        
        if (self.block) {
            
            self.block(self.leftPicImageView.isAnimating);
        }
    }
    
}

- (void)rightPicImageViewClicked {
    
    if (self.chatItem.states == voiceStates) {
        
        if (self.rightPicImageView.isAnimating) {
            
            [self.rightPicImageView stopAnimating];
        } else {
            
            [self.rightPicImageView startAnimating];
        }
        
        if (self.block) {
            
            self.block(self.rightPicImageView.isAnimating);
        }
    }
    
    
}

- (void)endPlaying {
    
    if (self.rightPicImageView.isAnimating) {
        
        [self.rightPicImageView stopAnimating];
    } else if (self.leftPicImageView.isAnimating) {
        
        [self.leftPicImageView stopAnimating];
    }
}

- (void)setBlock:(PlayTheRecordAudio)block {
    
    _block = block;
}

- (void)setChatItem:(UToChatItem *)chatItem {
    
    _chatItem = chatItem;
    [self updateUI];
}

- (void)updateUI {
    
    CGFloat width = SCREEN_WIDTH*3/4-LeftMargin-30-PixelSpacing-RightMargin-PixelSpacing-LeftMargin-PixelSpacing-5;
    
    if (self.chatItem.states == textStates) {
        
        NSString *string = [NSKeyedUnarchiver unarchiveObjectWithData:_chatItem.data];
        CGRect bound = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MessageLabelFont} context:nil];
        bound.size.width += PixelSpacing*2+LeftMargin+RightMargin+2;
        bound.size.height += PixelSpacing*3;
        
        //如果自己发的
        if(self.chatItem.isSelf) {
            
            self.rightLabel.hidden = NO;
            self.rightPicImageView.hidden = YES;
            self.rightLabel.text = string;
            [self.rightBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(bound.size.width);
                make.height.mas_equalTo(bound.size.height);
            }];
        } else {
            
            self.leftLabel.text = string;
            self.leftLabel.hidden = NO;
            self.leftPicImageView.hidden = YES;
            [self.leftBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(bound.size.width);
                make.height.mas_equalTo(bound.size.height);
            }];
        }
    } else if (self.chatItem.states == picStates) {
        
        //如果自己发的
        if(self.chatItem.isSelf) {
            
            self.rightLabel.hidden = YES;
            self.rightPicImageView.hidden = NO;
            UIImage *image = [UIImage imageWithData:self.chatItem.data];
            self.rightPicImageView.image = image;
            CGSize size = image.size;
            if (size.width > width) {
                
                size.height = width/size.width*size.height;
            } else {
                
                
            }
            size.width += LeftMargin+RightMargin;
            size.height += TopMargin+BottomMargin+PixelSpacing*2;
            [self.rightBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
            }];
        } else {
            
            self.leftLabel.hidden = YES;
            self.leftPicImageView.hidden = NO;
            UIImage *image = [UIImage imageWithData:self.chatItem.data];
            self.leftPicImageView.image = image;
            CGSize size = image.size;
            if (size.width > width) {
                
                size.height = width/size.width*size.height;
            } else {
                
                
            }
            size.width += LeftMargin+RightMargin;
            size.height += TopMargin+BottomMargin+PixelSpacing*2;
            [self.leftBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
            }];
        }
    } else if (self.chatItem.states == voiceStates) {
        
        //如果自己发的
        if(self.chatItem.isSelf) {
            
            self.rightLabel.hidden = YES;
            self.rightPicImageView.hidden = NO;
            UIImage *image = [UIImage imageNamed:@"message_voice_sender_normal"];
            self.rightPicImageView.image = image;
            CGSize size = image.size;
            if (size.width > width) {
                
                size.height = width/size.width*size.height;
            } else {
                
                
            }
            size.width += LeftMargin+RightMargin;
            size.height += TopMargin+BottomMargin+PixelSpacing*2;
            [self.rightBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
            }];
            self.rightPicImageView.animationImages = @[
                                                       [UIImage imageNamed:@"message_voice_sender_playing_1"],
                                                       [UIImage imageNamed:@"message_voice_sender_playing_2"],
                                                       [UIImage imageNamed:@"message_voice_sender_playing_3"],
                                                       ];
            self.rightPicImageView.animationDuration = 1.0;
        } else {
            
            self.leftLabel.hidden = YES;
            self.leftPicImageView.hidden = NO;
            UIImage *image = [UIImage imageNamed:@"message_voice_receiver_normal"];
            self.leftPicImageView.image = image;
            CGSize size = image.size;
            if (size.width > width) {
                
                size.height = width/size.width*size.height;
            } else {
                
                
            }
            size.width += LeftMargin+RightMargin;
            size.height += TopMargin+BottomMargin+PixelSpacing*2;
            [self.leftBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
            }];
            self.leftPicImageView.animationImages = @[
                                                      [UIImage imageNamed:@"message_voice_receiver_playing_1"],
                                                      [UIImage imageNamed:@"message_voice_receiver_playing_2"],
                                                      [UIImage imageNamed:@"message_voice_receiver_playing_3"],
                                                      ];
            self.leftPicImageView.animationDuration = 1.0;
        }
    } else if (self.chatItem.states == videoStates) {
        
        //如果自己发的
        if(self.chatItem.isSelf) {
            
            self.rightLabel.hidden = YES;
            self.rightPicImageView.hidden = NO;
            UIImage *image = [UIImage imageNamed:@"message_voice_sender_normal"];
            self.rightPicImageView.image = image;
            CGSize size = image.size;
            if (size.width > width) {
                
                size.height = width/size.width*size.height;
            } else {
                
                
            }
            size.width += LeftMargin+RightMargin;
            size.height += TopMargin+BottomMargin+PixelSpacing*2;
            [self.rightBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
            }];
        } else {
            
            self.leftLabel.hidden = YES;
            self.leftPicImageView.hidden = NO;
            UIImage *image = [UIImage imageNamed:@"message_voice_receiver_normal"];
            self.leftPicImageView.image = image;
            CGSize size = image.size;
            if (size.width > width) {
                
                size.height = width/size.width*size.height;
            } else {
                
                
            }
            size.width += LeftMargin+RightMargin;
            size.height += TopMargin+BottomMargin+PixelSpacing*2;
            [self.leftBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(size.width);
                make.height.mas_equalTo(size.height);
            }];
        }
    }
    
    [self showViewIsSelf:self.chatItem.isSelf];
}

- (void)showViewIsSelf:(BOOL)isSelf {
    
    if (isSelf) {
        
        self.leftGroundView.hidden = YES;
        self.rightGroundView.hidden = NO;
    } else {
        
        self.leftGroundView.hidden = NO;
        self.rightGroundView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
