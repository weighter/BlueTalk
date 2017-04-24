//
//  UToChatCell.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToChatCell.h"

@implementation UToChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    
    leftImgae = [leftImgae stretchableImageWithLeftCapWidth:30 topCapHeight:35];
    rightImage = [rightImage stretchableImageWithLeftCapWidth:30 topCapHeight:35];
    
    //----------------------------------------------------------------------------------------//
    self.leftHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    self.leftHeadImage.layer.masksToBounds = YES;
    self.leftHeadImage.layer.cornerRadius = 12;
    self.leftHeadImage.image = [UIImage imageNamed:@"f-pCert.png"];
    [self.contentView addSubview:self.leftHeadImage];
    
    self.leftVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftVideoButton.frame = CGRectMake(40, 5, 35, 35);
    //    [self.leftVideoButton addTarget:self action:@selector(recordTheVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftVideoButton];
    
    self.leftPicImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 66, 30)];
    [self.contentView addSubview:self.leftPicImage];
    
    self.lefeView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 66, 30)];
    self.lefeView.image = leftImgae;
    [self.contentView addSubview:self.lefeView];
    
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 1, 1)];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    
    self.leftLabel.numberOfLines = 0;
    
    self.leftLabel.backgroundColor = [UIColor clearColor];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
