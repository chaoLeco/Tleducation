//
//  UIView+HUD.h
//  newruishihui
//
//  Created by Chaos on 16/4/14.
//  Copyright © 2016年 iUXLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)showHUDWithHint:(NSString *)hint;

// 下载动画HUD
- (void)showHUDDeterminat;
- (void)HUDProgress:(CGFloat)progress;
@end
