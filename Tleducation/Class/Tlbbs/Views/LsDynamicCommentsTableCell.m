//
//  LsDynamicCommentsTableCell.m
//  lushangjituan
//
//  Created by Chaos on 16/9/2.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "LsDynamicCommentsTableCell.h"
#import "NSDate+Category.h"
#import "NSString+Emoji.h"
@implementation LsDynamicCommentsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValueData:(YdDynamicComment *)data
{
    _data = data;
    [_lblName setText:data.nickname];
    [_lblTime setText:[NSDate formattedTimeFromTimeInterval:[data.time longLongValue]]];
    NSString *info = [data.title stringByReplacingEmojiCheatCodesWithUnicode];
    if ([data.cuid isEqualToString:@""] ||
        [data.cuid isEqualToString:@"0"]||
         !data.cuid) {
         [_lblComments setText:info];
    }else{
         [_lblComments setText:[NSString stringWithFormat:@"回复 %@：%@",data.nickname,info]];
    }
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]];
    NSString *str = [NSString stringWithFormat:@"%@%@",Yd_Url_base,data.headimg];
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:image];
}

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu=[UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItemClicked:)];
        UIMenuItem *delItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(delItemClicked:)];
        NSArray *items;
        if (_isSelfDy || [_data.cuid isEqualToString:k_GET_OBJECT(Yd_user)]) {
            items = @[copyItem,delItem];
        }else items = @[copyItem];
        [menu setMenuItems:items];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}



#pragma mark 处理action事件
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action ==@selector(copyItemClicked:)){
        return YES;
    }else if (action==@selector(delItemClicked:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}
#pragma mark  实现成为第一响应者方法
-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark method
-(void)delItemClicked:(id)sender{
    
    //通知代理
    if (_block) {
        NSLog(@"删除");
        _block(1,_data.commentid);
    }
}
-(void)copyItemClicked:(id)sender{
    
    if (_block) {
        NSLog(@"复制");
        _block(0,_data.commentid);
    }
    [UIPasteboard generalPasteboard].string = [_data.title stringByReplacingEmojiCheatCodesWithUnicode];
}
@end

@implementation LsDynamicThingListTableCell

-(void)setThingList:(NSArray *)realnames
{
    if (realnames.count>0) {
        NSString *names=@"";
        for (NSDictionary *dic in realnames) {
            names = [NSString stringWithFormat:@"%@,%@",names,dic[@"realname"]];
        }
        names = [names substringFromIndex:1];
        _lblThingList.text = [NSString stringWithFormat:@"      %@",names];
    }
}


@end
