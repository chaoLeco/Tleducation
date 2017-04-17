//
//  YdMallSearchViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/13.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdMallSearchViewController.h"
#import "YdtlmallTableViewCell.h"
#import "YdproductViewController.h"
@interface YdMallSearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (strong,nonatomic) NSMutableArray *datas;
@end

@implementation YdMallSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setTableFooterView:[UIView new]];
    if (_searchTxt) {
        _searchbar.text = _searchTxt;
        [self getDataSource];
    }else{
        [self showHint:@"么啥可搜的"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdtlmallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdtlmallTableViewCell"];
    [cell showValue:_datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"pushYdmallViewControllerSegue" sender:_datas[indexPath.row]];
}
- (void)getDataSource
{
    [self showHUDWithHint:nil];
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_mall_product Params:@{@"key":_searchbar.text} success:^(id json) {
        [self hideHud];
        if ([self status:json]) {
            _datas = [NSMutableArray array];
            NSArray *arry = json[@"data"];
            for (NSDictionary *dic in arry) {
                NSError *error;
                YdtlmallModel *model = [[YdtlmallModel alloc]initWithDictionary:dic error:&error];
                [_datas addObject:model];
            }
            [_tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHud];
        [self showHint:@"网络错误"];
    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self getDataSource];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdproductViewController class]]) {
        YdproductViewController *ppvc = (YdproductViewController *)vc;
        ppvc.product = sender;
    }
}


@end
