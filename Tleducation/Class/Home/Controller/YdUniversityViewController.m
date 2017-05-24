//
//  YdUniversityViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/5/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdUniversityViewController.h"
#import "YdwebViewController.h"
#import "YdUniversityTableCell.h"
#import "Yduniversity.h"
#import "OrderPickerView.h"
@interface YdUniversityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (strong,nonatomic) NSString *attr;
@property (strong,nonatomic) NSMutableDictionary *params;
@property (strong,nonatomic) NSMutableArray *datas;
@end

@implementation YdUniversityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tableRefresh:_tableView];
    [self getDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)attrAction:(UIButton *)sender {
    //层次/本科高校/专科高校/独立学院/民办高校
    [OrderPickerView showViewStyleDefaultWithData:@[@"属性",@"本科高校",@"专科高校",@"独立学院",@"民办高校"] Block:^(id data, NSIndexPath *path) {
        if (data) {
            [sender setTitle:data forState:UIControlStateNormal];
            _attr = nil;
            if (path.row>0) {
                _attr = data;
            }
        }
    }];
}

- (IBAction)searchAction:(id)sender {
    [_searchbar resignFirstResponder];
    if (_searchbar.text.length>0) {
        self.nowPage=1;
       [self getDataSource];
    }else
        _searchbar.text = nil;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.nowPage=1;
    [self getDataSource];
}

- (void)getDataSource
{
    if (_tableView.mj_header.state == MJRefreshStateRefreshing) {
        _attr = nil;
        _searchbar.text = nil;
        [_searchbar resignFirstResponder];
        [(UIButton *)[self.view viewWithTag:100] setTitle:@"属性" forState:UIControlStateNormal];
    }
    _params = [NSMutableDictionary dictionary];
    [_params setObject:[NSString stringWithFormat:@"%ld",(long)self.nowPage] forKey:@"page"];
    if (_attr) {
        [self.params setObject:_attr forKey:@"attr"];
    }
    if (_searchbar.text.length>0) {
        [_params setObject:_searchbar.text forKey:@"search_key"];
    }
    [self showHUDWithHint:nil];
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_home_university Params:_params success:^(id json) {
        if ([self status:json]) {
            if (self.nowPage ==1) {
                _datas = [NSMutableArray array];
            }
            self.totalPage = [json[@"max"] integerValue];
            NSArray *ary = json[@"data"];
            for (NSDictionary *dic in ary) {
                NSError *error;
                Yduniversity *un = [[Yduniversity alloc] initWithDictionary:dic error:&error];
                if (!error) {
                    [_datas addObject:un];
                }
            }
            [_tableView reloadData];
        }
        [self hideHud];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self hideHud];
        [self showHint:@"获取失败"];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YdUniversityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdUniversityTableCell"];
    cell.lblName.text = @"大学名称";
    cell.lbllevels.text = @"层次";
    cell.lnlarea.text = @"区域";
    cell.lbladministration.text = @"主管部门";
    cell.lineView.hidden = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdUniversityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdUniversityTableCell"];
    [cell showValue:_datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Yduniversity *model = _datas[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"pushYdwebViewControllerSegue" sender:model];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdwebViewController class]]) {
        YdwebViewController *web = (YdwebViewController *)vc;
        web.url = [(Yduniversity *)sender url];
        web.title = [(Yduniversity *)sender name];
    }
}


@end
