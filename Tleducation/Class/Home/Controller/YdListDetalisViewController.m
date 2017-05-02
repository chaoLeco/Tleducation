//
//  YdListDetalisViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdListDetalisViewController.h"
#import "YdListDeatlisTableViewCell.h"
#import "SDCycleScrollView.h"
@interface YdListDetalisViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *banner;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@end

@implementation YdListDetalisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.estimatedRowHeight = 100.f;
    _tableview.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableview.estimatedSectionHeaderHeight = 30.f;
    self.cycleScrollView.localizationImageNamesGroup = @[@"ad_1.jpg",@"ad_2.jpg",@"ad_3.jpg",@"ad_4.jpg"];
    [_banner addSubview:_cycleScrollView];
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_banner.bounds delegate:self placeholderImage:nil];
    }
    return _cycleScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YdListDeatlisTableSection *sectionView = [tableView dequeueReusableCellWithIdentifier:@"YdListDeatlisTableSection"];
    if (section==0) {
        sectionView.lbltitle.text = @"学校简介";
    }else
        sectionView.lbltitle.text = @"学校评价";
    return sectionView;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        YdListDeatlisTableViewCell_title *cell = [tableView dequeueReusableCellWithIdentifier:@"YdListDeatlisTableViewCell_title"];
        return cell;
    }else{
        YdListDeatlisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdListDeatlisTableViewCell"];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - SDCycleScrollViewDelegate -
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    NSLog(@"点击了第%ld个",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    //    NSLog(@"当前位置%ld",index);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
