//
//  YdListViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdListViewController.h"
#import "YdhomeListTableViewCell.h"
#import "YdListDetalisViewController.h"
#import "YdtlmallModel.h"

@interface YdListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;
@end

@implementation YdListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _ch.st;
    [self getDataSource];
    [self tableRefresh:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YdhomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdhomeListTableViewCell"];
    [cell setValueData:_datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushYdListDetalisViewControllerSegue" sender:_datas[indexPath.row]];
}

- (void)getDataSource
{
    if (!_ch) {
        [self showHint:@"无法获取内容"];
        return;
    }
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_home_product_tt Params:@{@"ttid":_ch._id} success:^(id json) {
        if ([self status:json]) {
            _datas = [NSMutableArray array];
            NSArray *ary = json[@"data"];
            for (NSDictionary *dic in ary) {
                NSError *error;
                YdtlmallModel *model = [[YdtlmallModel alloc]initWithDictionary:dic error:&error];
                if (!error) {
                    [_datas addObject:model];
                }
            }
            [_tableView reloadData];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdListDetalisViewController class]]) {
        YdListDetalisViewController *detail = [segue destinationViewController];
        detail.model = sender;
    }
}


@end
