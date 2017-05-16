//
//  YdHomeTableViewCell.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdHomeTableViewCell.h"

@implementation YdHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showValue:(YdhomeModel *)value
{
    _lblMake.text = value.type;
    _lbltitle.text = value.title;
    _lbltime.text = [value.time stringDateWithFormat:@"yyyy.MM.dd HH:mm"];
    [_img sd_setImageWithURL:[NSURL URLWithString:[Yd_Url_base stringByAppendingString:value.img]] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
}

@end
