//
//  YdtlmallTableViewCell.h
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdtlmallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UILabel *lblprice;
@property (weak, nonatomic) IBOutlet UILabel *lblprice_member;
@property (weak, nonatomic) IBOutlet UILabel *lblpnum;
@end
