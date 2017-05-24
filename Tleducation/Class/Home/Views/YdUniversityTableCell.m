//
//  YdUniversityTableCell.m
//  Tleducation
//
//  Created by lecochao on 2017/5/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdUniversityTableCell.h"

@implementation YdUniversityTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showValue:(Yduniversity *)un
{
    _lblName.text = un.name;
    _lnlarea.text = un.area;
    _lbllevels.text = un.levels;
    _lbladministration.text = un.administration;
    _lineView.hidden = YES;
}
@end
