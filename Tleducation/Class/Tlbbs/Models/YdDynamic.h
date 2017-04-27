//
//  YdDynamic.h
//  Tleducation
//
//  Created by lecochao on 2017/4/26.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YdDynamic : JSONModel
@property (nonatomic, retain) NSString *trendid;
@property (nonatomic, retain) NSString <Optional>*title;
@property (nonatomic, retain) NSString <Optional>*img;
@property (nonatomic, retain) NSString <Optional>*video;
@property (nonatomic, retain) NSString <Optional>*thumb;
@property (nonatomic, retain) NSString <Optional>*uid;
@property (nonatomic, retain) NSString <Optional>*time;
@property (nonatomic, retain) NSString <Optional>*ilike;
@property (nonatomic, retain) NSString <Optional>*nickname;
@property (nonatomic, retain) NSString <Optional>*headimg;
@end
//"trendid": "1",
//"title": "是因为自己人的时候胃疼是个什么都没有",
//"img": "",
//"video": "/trend_media/20170426101941_72959.mov",
//"uid": "10",
//"time": "1493173181",
//"ilike": "0"
