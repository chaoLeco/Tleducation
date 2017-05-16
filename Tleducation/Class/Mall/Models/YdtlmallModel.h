//
//  YdtlmallModel.h
//  Tleducation
//
//  Created by lecochao on 2017/4/12.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YdtlmallModel : JSONModel
@property (nonatomic, retain) NSString *productid;
@property (nonatomic, retain) NSString <Optional>*productname;
@property (nonatomic, retain) NSString <Optional>*ttname;
@property (nonatomic, retain) NSString <Optional>*productcat;
@property (nonatomic, retain) NSString <Optional>*productds;
@property (nonatomic, retain) NSString <Optional>*price;
@property (nonatomic, retain) NSString <Optional>*member_price;
@property (nonatomic, retain) NSString <Optional>*sales;
@property (nonatomic, retain) NSString <Optional>*storeid;
@property (nonatomic, retain) NSString <Optional>*storename;
@property (nonatomic, retain) NSString <Optional>*storeaddr;
@property (nonatomic, retain) NSString <Optional>*storetel;
@property (nonatomic, retain) NSString <Optional>*pimg;
@property (nonatomic, retain) NSString <Optional>*lat;
@property (nonatomic, retain) NSString <Optional>*lng;

@end



//"productid": "1",               //商品id
//"productname": "商品12",        //商品名称
//"ttname": "文化培训",            //培训类型
//"productcat": "乐器类",         //商品分类
//"productds": "133",         //商品详情
//"price": "123.00",              //商品价格
//"member_price": "101.00",       //会员价格
//"sales": "0",                   //销量
//"storeid": "1",                 //商品所属商家id
//"storename": "测试商家1",       //商家名称
//"storeaddr": "测试地址2",       //商家地址
//"storetel": "测试电话3",        //商家电话
//"lat": "36.6211500",		//商家纬度
//"lng": "101.7634600",		//商家经度
//"pimg": "/112"			//商品主题图片


