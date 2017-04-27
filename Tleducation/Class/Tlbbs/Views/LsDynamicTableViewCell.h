//
//  LsDynamicTableViewCell.h
//  lushangjituan
//
//  Created by Chaos on 16/8/26.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YdDynamic.h"
//#import "LsVideoPlayView.h"
#import "MCFireworksButton.h"
typedef NS_ENUM(NSInteger, LsDynamicClickStyle) {
    LsDynamicClickStyleUser,
    LsDynamicClickStylePicture1,
    LsDynamicClickStylePicture2,
    LsDynamicClickStylePicture3,
    LsDynamicClickStylePicture4,
    LsDynamicClickStylePicture5,
    LsDynamicClickStylePicture6,
    LsDynamicClickStyleVideo,
    LsDynamicClickStyleLeftBtn,
    LsDynamicClickStyleRightBtn,
    LsDynamicClickStyleLocationBtn

};



// 仅文字
@interface LsDynamicTableViewCell_Normal : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTing;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet MCFireworksButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
typedef void(^cellblock)(LsDynamicClickStyle style , id model ,id info);/**< info附带信息*/
@property (strong,nonatomic) cellblock block;


@property (strong,nonatomic) YdDynamic * data;

- (void)setValueData:(id)model;

@end


//单张图
@interface LsDynamicTableViewCell_Picture : LsDynamicTableViewCell_Normal
@property (weak, nonatomic) IBOutlet UIImageView *imgOnly;
@end

//多张图Dynamic
@interface LsDynamicTableViewCell_Pictures : LsDynamicTableViewCell_Normal
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@end

@interface LsDynamicTableViewCell_Pictures_6 : LsDynamicTableViewCell_Pictures
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;
@end

//视频
@interface LsDynamicTableViewCell_Video : LsDynamicTableViewCell_Normal
@property (weak, nonatomic) IBOutlet UIImageView *imgthum;
@property (strong,nonatomic) NSString *videoUrl;
@property (strong,nonatomic) NSString *thumbUrl;
@end
