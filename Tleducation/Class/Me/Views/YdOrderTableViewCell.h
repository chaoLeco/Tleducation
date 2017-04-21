//
//  YdOrderTableViewCell.h
//  Tleducation
//
//  Created by lecochao on 2017/4/19.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YdOrderDetail.h"
@interface YdOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrderid;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblpayStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgpr;


- (void)setValueData:(YdOrderDetail *)data;
@end
