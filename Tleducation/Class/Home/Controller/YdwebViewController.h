//
//  YdwebViewController.h
//  judiciary
//
//  Created by lecochao on 2017/2/22.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdBasisViewController.h"
#import "Ydxin.h"
#import "YdBanner.h"
@interface YdwebViewController : YdBasisViewController
@property (strong,nonatomic) Ydxin *xinInfo;
@property (strong,nonatomic) YdBanner *banner;
@property (strong,nonatomic) NSString *url;
@end
