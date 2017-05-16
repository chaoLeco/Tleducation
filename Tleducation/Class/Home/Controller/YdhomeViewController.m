//
//  YdhomeViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdhomeViewController.h"
#import "YdHomeTableViewCell.h"
#import "YdListViewController.h"
#import "YdListDetalisViewController.h"
#import "YdwebViewController.h"
#import "SDCycleScrollView.h"
#import "YdhomeModel.h"
#import "YdHomeMenu.h"
#import "YdBanner.h"

@interface YdhomeViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *banner;
@property (weak, nonatomic) IBOutlet YdHomeMenu *menuView;

@property (strong,nonatomic) NSMutableArray *datas;
@property (strong,nonatomic) NSMutableArray *banners;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@end

@implementation YdhomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cycleScrollView.localizationImageNamesGroup = @[@"ad_1.jpg"];
    [_banner addSubview:_cycleScrollView];
    [self tableRefresh:_tableView];
    [self getDataSource];
    _menuView.block =^(YdHomeClass *hc){
        [self performSegueWithIdentifier:@"pushYdListViewControllerSegue" sender:hc];
    };
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_banner.bounds delegate:self placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
    }
    return _cycleScrollView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdHomeTableViewCell"];
    [cell showValue:_datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YdhomeModel *model = _datas[indexPath.row];
    if ([model.pora isEqualToString:@"a"]) {
        [self performSegueWithIdentifier:@"pushYdwebViewControllerSegue" sender:model];
    }else if ([model.pora isEqualToString:@"p"]) {
        [self performSegueWithIdentifier:@"pushYdListDetalisViewControllerSegue" sender:model];
    }
    
}


#pragma mark - SDCycleScrollViewDelegate -
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    YdBanner *banner = _banners[index];
    if (banner.url.length>0) {
       [self performSegueWithIdentifier:@"pushYdwebViewControllerSegue" sender:banner];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    //    NSLog(@"当前位置%ld",index);
}

#pragma mark - action -

- (IBAction)btnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 105:
            //商城
            self.tabBarController.selectedIndex = 1;
            break;
        case 106:
            //每周之星
            [self performSegueWithIdentifier:@"pushYdxinViewControllerSegue" sender:@"4"];
            break;
        case 107:
            //全国大学
            break;
        default:
            break;
    }
}

#pragma mark - data - 

-(void)getDataSource
{
    [_menuView show];
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_home_top Params:nil success:^(id json) {
        if ([self status:json]) {
            _datas = [NSMutableArray new];
            NSArray *ary = json[@"data"];
            for (NSDictionary *dic in ary) {
                NSError *error;
                YdhomeModel *model = [[YdhomeModel alloc]initWithDictionary:dic error:&error];
                if (!error) {
                    [_datas addObject:model];
                }
            }
            [_tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
    }];
    [self getDataBanner];
}

- (void)getDataBanner
{
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_home_banner Params:nil success:^(id json) {
        if ([self status:json]) {
            _banners = [NSMutableArray new];
            NSMutableArray *urls = [NSMutableArray array];
            NSArray *ary = json[@"data"];
            for (NSDictionary *dic in ary) {
                NSError *error;
                YdBanner *model = [[YdBanner alloc]initWithDictionary:dic error:&error];
                if (!error) {
                    [_banners addObject:model];
                    [urls addObject:[Yd_Url_base stringByAppendingString:model.img]];
                }
            }
            self.cycleScrollView.imageURLStringsGroup = urls;
            [_tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdListViewController class]]) {
        YdListViewController *listvc = (YdListViewController *)vc;
        listvc.ch = sender;
    }
    if ([vc isKindOfClass:[YdwebViewController class]]) {
        YdwebViewController *webvc = (YdwebViewController *)vc;
        if ([sender isKindOfClass:[YdBanner class]]) {
            webvc.banner = sender;
        }
        if ([sender isKindOfClass:[YdhomeModel class]]) {
            YdhomeModel *model = (YdhomeModel*)sender;
            webvc.title = model.title;
            webvc.url = [NSString stringWithFormat:@"%@/star/%@",Yd_Url_base,model.sid];
        }
    }
    if ([vc isKindOfClass:[YdListDetalisViewController class]]) {
        YdListDetalisViewController *detail = [segue destinationViewController];
        detail.productid = [(YdhomeModel*)sender sid];
    }
}


@end
