//
//  STInputBar.h
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STInputBarDelegate <NSObject>
- (BOOL)textFild:(NSString *)text andTextView:(UITextView *)textView;
@end
@interface STInputBar : UIView

@property (nonatomic,weak) id<STInputBarDelegate>dataSource;
+ (instancetype)inputBar;

@property (assign, nonatomic) BOOL fitWhenKeyboardShowOrHide;

- (void)setDidSendClicked:(void(^)(NSString *text))handler;

@property (copy, nonatomic) NSString *placeHolder;

- (void)setInputBarSizeChangedHandle:(void(^)())handler;

- (BOOL)resignFirstResponder;
- (BOOL)becomeFirstResponder;
@end


