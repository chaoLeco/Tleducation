//
//  LsDynamicCommentsTableCell.m
//  lushangjituan
//
//  Created by Chaos on 16/9/2.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "LsDynamicCommentsTableCell.h"

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

//-(void)setValueData:(LsDynamicCommentModel *)data
//{
//    _data = data;
//    [_lblName setText:data.active_realname];
//    [_lblTime setText:[NSDate formattedTimeFromTimeInterval:[data.co_addtime longLongValue]]];
//    NSString *info = [data.co_comment_info stringByReplacingEmojiCheatCodesWithUnicode];
//    if ([data.co_passive_member isEqualToString:@""] ||
//        [data.co_passive_member isEqualToString:@"0"]||
//         !data.co_passive_member) {
//         [_lblComments setText:info];
//    }else{
//         [_lblComments setText:[NSString stringWithFormat:@"回复 %@：%@",data.passive_realname,info]];
//    }
//    NSString *str = [NSString stringWithFormat:@"%@%@",Ls_url_avatar_base,data.active_avatar];
//    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:Ls_preset]];
//}

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu=[UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItemClicked:)];
        UIMenuItem *delItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(delItemClicked:)];
        NSArray *items;
//        if (_isSelfDy || [_data.co_active_member isEqualToString:LSHL_GET_OBJECT(@"uid")]) {
//            items = @[copyItem,delItem];
//        }else items = @[copyItem];
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
    NSLog(@"删除");
    //通知代理
    if (_block) {
//        _block(1,_data.co_id);
    }
}
-(void)copyItemClicked:(id)sender{
    NSLog(@"复制");
    if (_block) {
//        _block(0,_data.co_id);
    }
//    [UIPasteboard generalPasteboard].string = [_data.co_comment_info stringByReplacingEmojiCheatCodesWithUnicode];
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
