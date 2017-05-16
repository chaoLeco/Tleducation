//
//  YdtlmallTableViewCell.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdtlmallTableViewCell.h"

@implementation YdtlmallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showValue:(YdtlmallModel*)value
{
    [_img sd_setImageWithURL:[NSURL URLWithString:[Yd_Url_base stringByAppendingString:value.pimg]] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
    _lbltitle.text = value.productname;
    _lblpnum.text = value.sales;
    _lblprice.text = value.price;
    _lblprice_member.text = value.member_price;
}

@end
