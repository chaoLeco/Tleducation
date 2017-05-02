//
//  YdHomeMenu.h
//  Tleducation
//
//  Created by lecochao on 2017/4/28.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YdHomeClass;
@interface YdHomeMenu : UIView
@property(weak ,nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic) NSMutableArray *menus;
typedef void(^btnBlock)(YdHomeClass *hc);
@property(strong ,nonatomic) btnBlock block;

- (void)show;
@end
#import <JSONModel.h>
@interface YdHomeClass : JSONModel
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *st;
@end
