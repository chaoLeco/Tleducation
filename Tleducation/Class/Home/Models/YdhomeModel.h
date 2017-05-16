//
//  YdhomeModel.h
//  Tleducation
//
//  Created by lecochao on 2017/4/12.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YdhomeModel : JSONModel
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString <Optional>*title;
@property (nonatomic, retain) NSString <Optional>*type;
@property (nonatomic, retain) NSString <Optional>*img;
@property (nonatomic, retain) NSString <Optional>*sid;
@property (nonatomic, retain) NSString <Optional>*pora;
@property (nonatomic, retain) NSString <Optional>*time;
@end

//"id": "1",
//"title": "每周之星四",			//标题
//"type": "每周之星",				//类型
//"img": "/i/20170428101248_88442.png",	//图片
//"sid": "13",				//源id
//"pora": "a"					//源数据:a为文章p为商品
