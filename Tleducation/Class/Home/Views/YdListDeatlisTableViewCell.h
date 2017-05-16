//
//  YdListDeatlisTableViewCell.h
//  Tleducation
//
//  Created by lecochao on 2017/2/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YdListDeatlisTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lblsubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lbltime;

@end

@interface YdListDeatlisTableSection : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@end

@interface YdListDeatlisTableViewCell_title : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblsubtitle;
@end
