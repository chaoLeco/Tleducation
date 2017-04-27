//
//  LsChooseImg.m
//  lushangjituan
//
//  Created by Chaos on 16/8/29.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "LsChooseImg.h"

@implementation LsChooseImg


- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
}


-(void)setData:(NSMutableArray<UIImage *> *)data
{
    _isFull = NO;
    _data = [NSMutableArray arrayWithArray:data];
    if (_data.count<6) {
        //小于六张 显示添加图片按钮
        [_data addObject:[UIImage imageNamed:@"add_contact.png"]];
        _isFull = NO;
    }else _isFull = YES;
    self.dataSource = self;
    self.delegate = self;
    [self reloadData];
    if (self.alpha<1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
    }
}

#pragma mark - table -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;//cell数量
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const identifier = @"LsChooseImgTableCell";
    LsChooseImgTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.imgView.image = _data[indexPath.row];
    cell.indexPath = indexPath;
    cell.block =^(NSIndexPath *ip){[self remove:ip];};
    cell.imgView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    if (indexPath.row == _data.count-1 &&!_isFull) {
        cell.remBtn.hidden = YES;
    }else cell.remBtn.hidden = NO;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_isFull && indexPath.row ==_data.count-1) {
        NSLog(@"添加照片");
        if (_block_addImg) {
            [_data removeLastObject];
            _block_addImg(6-_data.count);
        }
    }else{
        NSLog(@"查看照片");
        if (_block_lockImg) {
            _block_lockImg(indexPath.row);
        }
    }
}

-(void)remove:(NSIndexPath *)indexPath
{
    [self.data removeObjectAtIndex:indexPath.row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];

    if (_data.count==1) {
        [_data removeAllObjects];
    }

    if (_isFull &&_data.count<6) {
        //小于六张 显示添加图片按钮
        [_data addObject:[UIImage imageNamed:@"add_contact"]];
        _isFull = NO;
    }
    if (_block_removeImg) {
        _block_removeImg(indexPath.row);
    }
    [self reloadData];
}
@end


@implementation LsChooseImgTableCell

-(void)drawRect:(CGRect)rect
{
// _removeBtn.frame = CGRectMake(rect.size.height-30, rect.size.height-30, 30, 30);
//    [self addSubview:_removeBtn];

}
- (IBAction)removeAction:(id)sender
{
    if (_block) {
        _block(_indexPath);
    }
}
@end
