//
//  YdOrderTableViewCell.m
//  Tleducation
//
//  Created by lecochao on 2017/4/19.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdOrderTableViewCell.h"

@implementation YdOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValueData:(YdOrderDetail *)data
{
    _lblOrderid.text = data.orderid;
    _lblTime.text = [NSString stringDateFromString:data.ordertime];
    _lblTitle.text = data.productname;
    if ([data.pay_status intValue]==0) {
        _lblpayStatus.text = @"未支付";
    }else{
        _lblpayStatus.text = @"已支付";
        if([data.order_status intValue]==1){
           _lblpayStatus.text = @"已取货";
        }
    }
    
    [_imgpr sd_setImageWithURL:[NSURL URLWithString:[Yd_Url_base stringByAppendingString:data.productimg]]];
    
}

@end
