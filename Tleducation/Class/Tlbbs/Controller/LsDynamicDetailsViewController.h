//
//  LsDynamicDetailsViewController.h
//  lushangjituan
//
//  Created by Chaos on 16/9/2.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "YdDynamic.h"
#import "YdBasisViewController.h"
@interface LsDynamicDetailsViewController : YdBasisViewController
@property(nonatomic ,strong) NSString *cellIdentifier;
@property(nonatomic ,assign) YdDynamic *dynamicInfo;
@end
