//
//  YdUserOrderViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/18.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdUserOrderViewController.h"
#import "YdOrderDetailViewController.h"
#import "YdOrderTableViewCell.h"
#import "YdOrderDetail.h"
@interface YdUserOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation YdUserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setTableFooterView:[UITableView new]];
    [self tableRefresh:_tableView];
    [self getDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdOrderTableViewCell"];
    [cell setValueData:_dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"pushYdOrderDetailViewController" sender:_dataSource[indexPath.row]];
}

-(void)getDataSource
{
    if ([self isLogin]) {
        NSString *userid = k_GET_OBJECT(Yd_user);
        [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_User_orderlist Params:@{@"userid":userid} success:^(id json) {
            if ([self status:json]) {
                NSArray *array = json[@"data"];
                _dataSource = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    NSError *error;
                    YdOrderDetail *dd = [[YdOrderDetail alloc] initWithDictionary:dic error:&error];
                    if (!error) {
                        [_dataSource addObject:dd];
                    }
                } [_tableView reloadData];
            }else
                [self showHint:@"好想出错了😳"];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        } fail:^(NSError *error) {
            [self showHint:@"网络错误"];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdOrderDetailViewController
                           class]]) {
        
        YdOrderDetailViewController  *detailvc = (YdOrderDetailViewController *)vc;
        detailvc.detail = sender;
    }
}


@end
