//
//  YdtlmallViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdtlmallViewController.h"
#import "YdtlmallTableViewCell.h"
#import "YdtlmallModel.h"
#import "YdproductViewController.h"
#import "OrderPickerView.h"
#import "YdMallSearchViewController.h"
@interface YdtlmallViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UILabel *lblClass;
@property (strong,nonatomic) NSMutableDictionary *params;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;

@end

@implementation YdtlmallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableRefresh:_tableView];
    [self getDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _searchbar.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action -

- (IBAction)classAction:(id)sender {
    [OrderPickerView  showViewStyleDefaultWithData:@[@"全部",@"一类",@"二类",@"三类",@"四类"] Block:^(id data, NSIndexPath *path) {
        if (data) {
            _lblClass.text = data;
            [self.params setObject:data forKey:@"key"];
            [self getDataSource];
        }
    }];
}

- (IBAction)pirceAction:(UIButton *)sender {
    
    if (sender.selected) {
        // 降序 -- down
        [self.params setObject:@"down" forKey:@"pirce"];
    }else{
        // 升序 -- up
        [self.params setObject:@"up" forKey:@"pirce"];
    }
    sender.selected = !sender.selected;
    [self getDataSource];
}

- (IBAction)salesAction:(UIButton *)sender {
    if (sender.selected) {
        // 降序 -- down
        [self.params setObject:@"down" forKey:@"sales"];
    }else{
        // 升序 -- up
        [self.params setObject:@"up" forKey:@"sales"];
    }
    sender.selected = !sender.selected;
    [self getDataSource];
}

- (IBAction)searchAction:(id)sender {
    
    [self searchBarSearchButtonClicked:_searchbar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"pushYdMallSearchViewController" sender:searchBar.text];
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

-(NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (void)getDataSource
{
    if (_tableView.mj_header.isRefreshing) {
        //恢复默认值
        [self restore];
    }
    [self showHUDWithHint:nil];
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_mall_product Params:_params success:^(id json) {
        [self hideHud];
        if ([self status:json]) {
            _datas = [NSMutableArray array];
            NSArray *arry = json[@"data"];
            if (![arry isKindOfClass:[NSArray class]]) return;
            for (NSDictionary *dic in arry) {
                NSError *error;
                YdtlmallModel *model = [[YdtlmallModel alloc]initWithDictionary:dic error:&error];
                [_datas addObject:model];
            }
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self hideHud];
        [self showHint:@"网络错误"];
    }];
}

- (void)restore
{
    UIButton *btn = [self.view viewWithTag:101];
    [btn setSelected:NO];
    [btn setHighlighted:YES];
    UIButton *btn2 = [self.view viewWithTag:102];
    [btn2 setSelected:NO];
    [btn2 setHighlighted:YES];
    _lblClass.text = @"全部";
    _params = nil;
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
    
    if ([vc isKindOfClass:[YdMallSearchViewController class]]) {
        YdMallSearchViewController *searchVc = (YdMallSearchViewController *)vc;
        searchVc.searchTxt = sender;
    }
}


@end
