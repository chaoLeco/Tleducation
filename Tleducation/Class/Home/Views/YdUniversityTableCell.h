//
//  YdUniversityTableCell.h
//  Tleducation
//
//  Created by lecochao on 2017/5/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Yduniversity.h"

@interface YdUniversityTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lnlarea;
@property (weak, nonatomic) IBOutlet UILabel *lbllevels;
@property (weak, nonatomic) IBOutlet UILabel *lbladministration;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)showValue:(Yduniversity *)un;
@end
