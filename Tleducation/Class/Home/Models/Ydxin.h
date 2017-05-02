//
//  Ydxin.h
//  Tleducation
//
//  Created by lecochao on 2017/4/28.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Ydxin : JSONModel
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString <Optional>*st;
@property (nonatomic, retain) NSString <Optional>*dc;
@property (nonatomic, retain) NSString <Optional>*ds;
@property (nonatomic, retain) NSString <Optional>*epic;
@property (nonatomic, retain) NSString <Optional>*dt;
@end

//"id": "13",                         //文章id
//"st": "每周之星四",                        //文章标题
//"ds": "每周之星四",                  //截取的正文内容200个字符
//"dc": "star/13"                        //文章详情链接
//"epic": "/i/20170428101248_88442.png",   //图片
//"dt": "1493350151"
