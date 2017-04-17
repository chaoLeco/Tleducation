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
    switch ([value.pa intValue]) {
        case 1:
            _lblMake.text = @"文章类目一";
            break;
        case 2:
            _lblMake.text = @"文章类目二";
            break;
        case 3:
            _lblMake.text = @"文章类目三";
            break;
        case 4:
            _lblMake.text = @"文章类目四";
            break;
        default:
            break;
    }
    _lbltitle.text = value.st;
    _lbltime.text = [value.dt stringDateWithFormat:@"yyyy.MM.dd HH:mm"];
    [_img sd_setImageWithURL:[NSURL URLWithString:value.ipic] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
}

@end
