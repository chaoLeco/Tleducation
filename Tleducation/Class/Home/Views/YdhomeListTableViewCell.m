//
//  YdhomeListTableViewCell.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdhomeListTableViewCell.h"

@implementation YdhomeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueData:(YdtlmallModel *)val
{
    _lbltitle.text = val.productname;
    _lbladdress.text = [NSString stringWithFormat:@"地址：%@",val.storeaddr];
    _lblpnum.text = [NSString stringWithFormat:@"已报名：%@人",val.sales];
}

@end
