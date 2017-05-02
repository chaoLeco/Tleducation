//
//  Ydxin.m
//  Tleducation
//
//  Created by lecochao on 2017/4/28.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "Ydxin.h"

@implementation Ydxin
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_id": @"id"}];
}
@end
