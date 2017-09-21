//
//  UToChatCell.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToChatCell.h"

@implementation UToChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeView];
    }
    return self;
}
-(void)makeView
{
    UIImage * leftImgae = [UIImage imageNamed:@"ReceiverTextNodeBkg.png"];
    UIImage * rightImage = [UIImage imageNamed:@"SenderTextNodeBkg.png"];
    
    //这里设定一行一像素 当图片拉伸的时候，只放大两个像素
    
    leftImgae = [leftImgae stretchableImageWithLeftCapWidth:30 topCapHeight:35];
    // 找一行一列的像素
    rightImage = [rightImage stretchableImageWithLeftCapWidth:30 topCapHeight:35];
    // 设定完了后生成了一个新的image;
    
    //----------------------------------------------------------------------------------------//
    // 左边头像
    self.leftHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    self.leftHeadImage.layer.masksToBounds = YES;
    self.leftHeadImage.layer.cornerRadius = 12;
    self.leftHeadImage.image = [UIImage imageNamed:@"f-pCert.png"];
    [self.contentView addSubview:self.leftHeadImage];
    
    //左边气泡
    self.leftVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftVideoButton.frame = CGRectMake(40, 5, 35, 35);
    //    [self.leftVideoButton addTarget:self action:@selector(recordTheVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftVideoButton];
    
    self.leftPicImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 66, 30)];
    [self.contentView addSubview:self.leftPicImage];
    
    self.lefeView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 66, 30)];
    self.lefeView.image = leftImgae;
    // 这里不是一个小像素的图片？？
    [self.contentView addSubview:self.lefeView];
    
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 1, 1)];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    
    self.leftLabel.numberOfLines = 0; // 换行
    
    self.leftLabel.backgroundColor = [UIColor clearColor];// 设置透明的
    
    [self.lefeView addSubview:self.leftLabel];
    
    //----------------------------------------------------------------------------------------//
    
    self.rightHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 35, 5, 30, 30)];
    self.rightHeadImage.layer.masksToBounds = YES;
    self.rightHeadImage.layer.cornerRadius = 12;
    self.rightHeadImage.image = [UIImage imageNamed:@"f-plove.png"];
    [self.contentView addSubview:self.rightHeadImage];
    
    self.rightVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightVideoButton.frame = CGRectMake(self.frame.size.width - 45 - 40, 5, 35, 35);
    //    [self.rightVideoButton addTarget:self action:@selector(recordTheVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightVideoButton];
    
    self.rightPicImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 45 - 30, 5, 30, 30)];
    [self.contentView addSubview:self.rightPicImage];
    
    // 右边
    self.rightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - (66+40), 5, 66, 30)];
    self.rightView.image = rightImage;
    [self.contentView addSubview:self.rightView];
    
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 1, 1)];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.numberOfLines = 0;
    [self.rightView addSubview:self.rightLabel];
    
    
    
    
}

//- (void)recordTheVoice
//{
//    [self.delegate cellSelectIndex];
//}

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    NSLog(@"%f,%f",size.width,size.height);
    
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf)
        returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}

//泡泡语音
- (UIView *)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
    
    //根据语音长度
    int yuyinwidth = 66+fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexRow;
    if(fromSelf)
        button.frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
    else
        button.frame =CGRectMake(position, 10, yuyinwidth, 54);
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%ld''",(long)logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    return button;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
