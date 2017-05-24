//
//  Yduniversity.h
//  Tleducation
//
//  Created by lecochao on 2017/5/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Yduniversity : JSONModel
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString <Optional>*name;
@property (nonatomic, retain) NSString <Optional>*administration;
@property (nonatomic, retain) NSString <Optional>*area;
@property (nonatomic, retain) NSString <Optional>*location;
@property (nonatomic, retain) NSString <Optional>*levels;
@property (nonatomic, retain) NSString <Optional>*url;
@property (nonatomic, retain) NSString <Optional>*attr;
@end
//"id": "1",
//"name": "北京大学",		//学校名称
//"administration": "教育部",	//主管部门
//"area": "北京",			//省份区域
//"location": "北京市",		//所在地
//"levels": "本科",			//层次
//"url": "http://www.pku.edu.cn/",	//学校网址
//"attr": "本科高校"			//属性
