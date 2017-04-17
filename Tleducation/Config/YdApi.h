//
//  YdApi.h
//  judiciary
//
//  Created by lecochao on 2017/2/21.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#ifndef YdApi_h
#define YdApi_h


#endif /* YdApi_h */


#pragma mark - api基础 -

#define Yd_Url_base @"http://192.168.10.250/"


#pragma mark - 文章类 -

//文章类别
#define Yd_Url_home_class Yd_Url_base@"class"
//置顶文章
#define Yd_Url_home_top Yd_Url_base@"top"
//商品列表
#define Yd_Url_mall_product Yd_Url_base@"product"
// 获取验证码
#define Yd_Url_User_CodePic Yd_Url_base@"validate"
//获取userInfo
#define Yd_Url_User_info Yd_Url_base@"user"
//密码登录
#define Yd_Url_Login_password Yd_Url_base@"pass_signin"
//codeMsg登录
#define Yd_Url_Login_codeMsg Yd_Url_base@"signin"
//获取短信验证码
#define Yd_Url_get_codeMsg Yd_Url_base@"sendcode"
