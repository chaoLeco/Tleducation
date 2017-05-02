//
//  YdHomeMenu.m
//  Tleducation
//
//  Created by lecochao on 2017/4/28.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdHomeMenu.h"
#import "UIView+HUD.h"
@implementation YdHomeMenu

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)show
{
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_home_class Params:nil success:^(id json) {
        if ([json[@"status"] intValue]==1) {
            NSArray *array = json[@"data"];
            _menus = [NSMutableArray array];
            for (UIView *view in _scrollView.subviews) {
                [view removeFromSuperview];
            }
            for (NSDictionary *dic in array) {
                NSError *error;
                YdHomeClass *hc = [[YdHomeClass alloc] initWithDictionary:dic error:&error];
                if (!error) {
                    [_menus addObject:hc];
                }
            }
            [self setUIBtn];
        }
    } fail:^(NSError *error) {
        [self showHint:@"获取失败！"];
    }];
}

- (void)setUIBtn
{
    CGFloat w = 0;
    for (int i=0; i<_menus.count; i++) {
        YdHomeClass *hc = _menus[i];
        UIButton *btn = [self setBtnWith:hc];
        CGFloat x = (i*2+1)*CGRectGetWidth(self.bounds)/8;
        btn.center = CGPointMake(x, CGRectGetHeight(self.bounds)/2);
        w = w + CGRectGetWidth(self.bounds)/4;
    }
    _scrollView.contentSize = CGSizeMake(w, CGRectGetHeight(self.bounds));
}

- (UIButton *)setBtnWith:(YdHomeClass *)hc
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 70)];
    btn.tag = 100 + [hc._id intValue];
    [btn setTitle:hc.st forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"Yd_class_%ld",btn.tag%6]];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(25, -50, -25, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-15, 5, 0, 0)];
    [_scrollView addSubview:btn];
    return btn;
}

- (void)btnAction:(UIButton*)btn
{
    for (YdHomeClass *hc in _menus) {
        if ([hc._id intValue]==btn.tag-100) {
            if (_block) {
                _block(hc);
            }
        }
    }
    
}

@end


@implementation YdHomeClass

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_id": @"id"}];
}

@end
