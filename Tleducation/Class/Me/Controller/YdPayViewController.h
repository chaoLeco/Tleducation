//
//  YdPayViewController.h
//  Tleducation
//
//  Created by lecochao on 2017/4/18.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdBasisViewController.h"
#import "YdOrderDetail.h"
#import "Ydvip.h"
@interface YdPayViewController : YdBasisViewController
@property(nonatomic ,strong) YdOrderDetail *detail;
@property(nonatomic ,strong) Ydvip *vipOrder;
@end
