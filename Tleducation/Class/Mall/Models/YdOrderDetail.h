//
//  YdOrderDetail.h
//  Tleducation
//
//  Created by lecochao on 2017/4/19.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YdOrderDetail : JSONModel

@property (nonatomic, retain) NSString *orderid;
@property (nonatomic, retain) NSString <Optional>*ordertime;
@property (nonatomic, retain) NSString <Optional>*pay_status;
@property (nonatomic, retain) NSString <Optional>*order_status;
@property (nonatomic, retain) NSString <Optional>*pname;
@property (nonatomic, retain) NSString <Optional>*pphone;
@property (nonatomic, retain) NSString <Optional>*pid;
@property (nonatomic, retain) NSString <Optional>*uid;
@property (nonatomic, retain) NSString <Optional>*sid;
@property (nonatomic, retain) NSString <Optional>*ordercode;
@property (nonatomic, retain) NSString <Optional>*productname;
@property (nonatomic, retain) NSString <Optional>*sum;
@property (nonatomic, retain) NSString <Optional>*storename;
@property (nonatomic, retain) NSString <Optional>*storeaddr;
@property (nonatomic, retain) NSString <Optional>*storetel;
@property (nonatomic, retain) NSString <Optional>*lat;
@property (nonatomic, retain) NSString <Optional>*lng;
@property (nonatomic, retain) NSString <Optional>*username;
@property (nonatomic, retain) NSString <Optional>*usertel;
@property (nonatomic, retain) NSString <Optional>*productimg;
@end
//"orderid": "2017041199971005",  //订单id号
//"ordertime": "1491895212",      //订单下单时间
//"pay_status": "0",              //订订单支付状态:0未支付 1已支付
//"order_status","0",		//订单状态即取货状态:0未取货/1已取货
//"pname":"张三",                 //购买者姓名
//"pphone":"12345678901",         //购买者手机号码
//"ordercode":"34826517",         //订单密码
//"pid":"3",                      //商品id
//"productname": "商品2",         //商品名称
//"productimg":"",                //商品图片
//"sum": "2500.00",               //付款金额
//"storename": "测试商家1",       //商家名称
//"storeaddr": "测试地址2",       //商家地址
//"storetel": "测试电话3",        //商家电话
//"lat": "36.6211500",            //商家纬度
//"lng": "101.7634600",           //商家经度
//"username": "王大锤",           //用户姓名
//"usertel": "12345678901"        //用户电话
