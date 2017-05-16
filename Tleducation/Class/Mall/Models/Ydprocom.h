//
//  Ydprocom.h
//  Tleducation
//
//  Created by lecochao on 2017/5/9.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Ydprocom : JSONModel
@property (nonatomic, retain) NSString *procomid;
@property (nonatomic, retain) NSString <Optional>*pid;
@property (nonatomic, retain) NSString <Optional>*title;
@property (nonatomic, retain) NSString <Optional>*uid;
@property (nonatomic, retain) NSString <Optional>*time;
@property (nonatomic, retain) NSString <Optional>*nickname;
@property (nonatomic, retain) NSString <Optional>*headimg;

@end
//"procomid": "1",
//"pid": "2",		//商品id
//"title": "很好",		//评论内容
//"uid": "2",		//评论者id
//"time": "1493344634",	//评论时间
//"nickname": "",		//评论者昵称
//"headimg": ""		//评论者头像
