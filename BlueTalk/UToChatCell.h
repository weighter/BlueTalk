//
//  UToChatCell.h
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol CellSelectIndex <NSObject>
//
//- (void)cellSelectIndex;
//
//@end

@interface UToChatCell : UITableViewCell

@property(nonatomic,strong)UIImageView * lefeView;
@property(nonatomic,strong)UIImageView * rightView;
@property(nonatomic,strong)UILabel * leftLabel;
@property(nonatomic,strong)UILabel * rightLabel;


@property(nonatomic,strong)UIImageView * leftHeadImage;
@property(nonatomic,strong)UIImageView * rightHeadImage;

@property(nonatomic,strong)UIImageView * leftPicImage;
@property(nonatomic,strong)UIImageView * rightPicImage;


@property(nonatomic ,strong)UIButton * leftVideoButton;
@property(nonatomic, strong)UIButton * rightVideoButton;

//@property(nonatomic,weak)id <CellSelectIndex> delegate;

@end
