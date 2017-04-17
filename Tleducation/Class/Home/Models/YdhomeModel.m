//
//  YdhomeModel.m
//  Tleducation
//
//  Created by lecochao on 2017/4/12.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdhomeModel.h"

@implementation YdhomeModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_id": @"id"}];
}
@end
