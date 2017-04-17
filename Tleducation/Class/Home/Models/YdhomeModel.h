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
@property (nonatomic, retain) NSString <Optional>*st;
@property (nonatomic, retain) NSString <Optional>*lv;
@property (nonatomic, retain) NSString <Optional>*ds;
@property (nonatomic, retain) NSString <Optional>*pa;
@property (nonatomic, retain) NSString <Optional>*dc;
@property (nonatomic, retain) NSString <Optional>*dt;
@property (nonatomic, retain) NSString <Optional>*ipic;
@end

//"id": "6",                      //文章id
//"st": "文章二",                 //文章标题
//"pa": "2",                      //所属类别
//"lv": "top",                    //文章置顶属性
//"ds": "",                       //文章概述
//"dc": "文章二",                 //文章详情
//"dt": "1491808872",             //发布时间
//"ipic": ""                      //文章主题图片
