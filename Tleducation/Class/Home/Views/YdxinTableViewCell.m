//
//  YdxinTableViewCell.m
//  Tleducation
//
//  Created by lecochao on 2017/2/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdxinTableViewCell.h"

@implementation YdxinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueData:(Ydxin *)value
{
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Yd_Url_base,value.epic]] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
    [_lbltitle setText:value.st];
    [_lblsubtitle setText:value.ds];
    [_lblpnum setText:[value.dt stringDateWithFormat:@"yyyy-MM-dd HH:mm"]];
}

@end
