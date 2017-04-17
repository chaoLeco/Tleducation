//
//  YdHomeTableViewCell.h
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YdhomeModel.h"
@interface YdHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UILabel *lbltime;
@property (weak, nonatomic) IBOutlet UILabel *lblMake;

- (void)showValue:(YdhomeModel*)value;

@end
