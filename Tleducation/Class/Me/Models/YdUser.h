//
//  YdUser.h
//  Tleducation
//
//  Created by lecochao on 2017/4/14.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YdUser : JSONModel
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString <Optional>*username;
@property (nonatomic, retain) NSString <Optional>*usertel;
@property (nonatomic, retain) NSString <Optional>*nickname;
@property (nonatomic, retain) NSString <Optional>*headimg;
@property (nonatomic, retain) NSString <Optional>*vip;
@property (nonatomic, retain) NSString <Optional>*exp;
@end

//"userid": "1",                      //用户id
//"username": "王大锤",               //用户姓名
//"usertel": "12345678901",           //用户手机号码
//"nickname": "",                     //用户昵称
//"headimg": ""                       //用户头像
//"vip":"0"                           //是否是会员
//"exp": "0",			//到期时间
