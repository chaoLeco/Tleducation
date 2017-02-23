//
//  YdhomeViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdhomeViewController.h"
#import "YdHomeTableViewCell.h"
#import "SDCycleScrollView.h"
@interface YdhomeViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *banner;

@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@end

@implementation YdhomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdHomeTableViewCell"];
    return cell;
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

#pragma mark - action -

- (IBAction)btnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        
            [self performSegueWithIdentifier:@"pushYdListViewControllerSegue" sender:@"1"];
            break;
        case 102:

            [self performSegueWithIdentifier:@"pushYdListViewControllerSegue" sender:@"2"];
            break;
        case 103:

            [self performSegueWithIdentifier:@"pushYdListViewControllerSegue" sender:@"3"];
            break;
        case 104:

            [self performSegueWithIdentifier:@"pushYdListViewControllerSegue" sender:@"4"];
            break;
        case 105:
            //商城
            break;
        case 106:
            //每周之星
            break;
        case 107:
            //全国大学
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
