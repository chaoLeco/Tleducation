//
//  YdBanner.h
//  Tleducation
//
//  Created by lecochao on 2017/5/9.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YdBanner : JSONModel
@property (nonatomic, retain) NSString *bannerid;
@property (nonatomic, retain) NSString <Optional>*img;
@property (nonatomic, retain) NSString <Optional>*title;
@property (nonatomic, retain) NSString <Optional>*url;
@end
//"bannerid": "1",									//数据id
//"img": "/i/20170508142219_31879.jpg",						//banner图片地址
//"title": "1111",									//图片文字标题
//"url": "2222",									//图片链接地址
