//
//  YdDynamicComment.h
//  Tleducation
//
//  Created by lecochao on 2017/4/27.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YdDynamicComment : JSONModel
@property (nonatomic, retain) NSString *commentid;
@property (nonatomic, retain) NSString <Optional>*tid;
@property (nonatomic, retain) NSString <Optional>*cuid;
@property (nonatomic, retain) NSString <Optional>*uid;
@property (nonatomic, retain) NSString <Optional>*title;
@property (nonatomic, retain) NSString <Optional>*time;
@property (nonatomic, retain) NSString <Optional>*nickname;
@property (nonatomic, retain) NSString <Optional>*headimg;
@end
//"commentid": "1",                   //评论数据id
//"tid": "1",                         //所被评论的动态id
//"cuid": "0",                        //所被评论的用户id
//"uid": "2",                         //发布评论者的id
//"title": "qw",                      //评论内容
//"time": "1493259183",               //评论时间
//"nickname": "",                     //发布评论者的昵称
//"headimg": ""                       //发布者的头像
