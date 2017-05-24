//
//  Yduniversity.m
//  Tleducation
//
//  Created by lecochao on 2017/5/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "Yduniversity.h"

@implementation Yduniversity
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_id": @"id"}];
}
@end
