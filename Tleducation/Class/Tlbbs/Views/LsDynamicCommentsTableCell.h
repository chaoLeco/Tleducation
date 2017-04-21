//
//  LsDynamicCommentsTableCell.h
//  lushangjituan
//
//  Created by Chaos on 16/9/2.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LsDynamicCommentModel.h"
@interface LsDynamicCommentsTableCell : UITableViewCell
@property (weak ,nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak ,nonatomic) IBOutlet UILabel *lblName;
@property (weak ,nonatomic) IBOutlet UILabel *lblComments;
@property (weak ,nonatomic) IBOutlet UILabel *lblTime;
//@property (strong,nonatomic) LsDynamicCommentModel *data;

@property (assign,nonatomic) BOOL isSelfDy;/**< 是否是自己的发布的动态*/
typedef void(^MenuBlcok)(NSInteger Index ,NSString *co_id);
@property (strong,nonatomic) MenuBlcok block;
//-(void)setValueData:(LsDynamicCommentModel *)data;
@end


@interface LsDynamicThingListTableCell : UITableViewCell
@property (weak ,nonatomic) IBOutlet UILabel *lblThingList;

- (void) setThingList:(NSArray *)realnames;
@end
