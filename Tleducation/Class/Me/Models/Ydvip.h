//
//  Ydvip.h
//  Tleducation
//
//  Created by lecochao on 2017/5/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Ydvip : JSONModel
@property (nonatomic, retain) NSString *orderid;
@property (nonatomic, retain) NSString <Optional>*ordertime;
@property (nonatomic, retain) NSString <Optional>*moon;
@property (nonatomic, retain) NSString <Optional>*uid;
@property (nonatomic, retain) NSString <Optional>*pay_status;
@property (nonatomic, retain) NSString <Optional>*sum;
@property (nonatomic, retain) NSString <Optional>*exp;
@end
//"id": "1",
//"orderid": "2017052350505451",	//订单号
//"ordertime": "1495509570",		//下单时间
//"uid": "3",				//用户id
//"moon": "3",			//购买月份数
//"exp": "1503285570",		//到期时间
//"sum": "360.00",			//应付金额
//"pay_status": "0"			//支付状态
