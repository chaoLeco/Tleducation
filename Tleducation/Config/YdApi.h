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

#define Yd_Url_base @"http://192.168.0.250/"


#pragma mark - 文章类 -

//文章类别
#define Yd_Url_home_class Yd_Url_base@"class"
//置顶文章
#define Yd_Url_home_top Yd_Url_base@"top"
//商品列表
#define Yd_Url_mall_product Yd_Url_base@"product"
//提交订单
#define Yd_Url_mall_submit Yd_Url_base@"order/submit"
// 获取验证码
#define Yd_Url_User_CodePic Yd_Url_base@"validate"
//获取userInfo
#define Yd_Url_User_info Yd_Url_base@"user"
//上传头像
#define Yd_Url_User_headimg Yd_Url_base@"up/headimg"
//修改密码
#define Yd_Url_User_editpassword Yd_Url_base@"user/edit/password"
//修改昵称
#define Yd_Url_User_editnickname Yd_Url_base@"user/edit/nickname"
//订单列表
#define Yd_Url_User_orderlist Yd_Url_base@"user/orderlist"
//订单详情
#define Yd_Url_User_order Yd_Url_base@"order"
//密码登录
#define Yd_Url_Login_password Yd_Url_base@"pass_signin"
//codeMsg登录
#define Yd_Url_Login_codeMsg Yd_Url_base@"signin"
//获取短信验证码74	184	123	
#define Yd_Url_get_codeMsg Yd_Url_base@"sendcode"
//动态--发布
#define Yd_Url_dy_posttrend Yd_Url_base@"post_trend"
//动态--列表
#define Yd_Url_dy_trendList Yd_Url_base@"trend"
//动态--发布评论
#define Yd_Url_dy_trendPostComment Yd_Url_base@"post_comment"
//动态--评论列表
#define Yd_Url_dy_trendCommentList Yd_Url_base@"comment"
//动态--删除
#define Yd_Url_dy_del_trend Yd_Url_base@"del_trend"
//动态--评论删除
#define Yd_Url_dy_del_comment Yd_Url_base@"del_comment"
//动态--点赞+1
#define Yd_Url_dy_del_add_ilike Yd_Url_base@"add_ilike"
