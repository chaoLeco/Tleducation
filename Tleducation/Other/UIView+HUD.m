//
//  UIView+HUD.m
//  newruishihui
//
//  Created by Chaos on 16/4/14.
//  Copyright © 2016年 iUXLabs. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIView (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [self HUD];
    if (!HUD) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide = NO;
    }
    HUD.bezelView.color = [UIColor whiteColor];
    HUD.label.text = hint;
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint {
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.offset = CGPointMake(hud.offset.x, 200.f);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.offset = CGPointMake(hud.offset.x, 200.f +yOffset);
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
}
- (void)showHUDWithHint:(NSString *)hint
{
    hint = @"";
    [self showHudInView:self hint:hint];
}

- (void)showHUDDeterminat
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.bezelView.color = [UIColor clearColor];
    [self addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)HUDProgress:(CGFloat)progress
{
    [MBProgressHUD HUDForView:self].progress = progress;
    
}
@end
