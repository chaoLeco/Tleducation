//
//  YdxinViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdxinViewController.h"
#import "YdxinTableViewCell.h"
#import "YdwebViewController.h"
#import "Ydxin.h"
@interface YdxinViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataSource;
@end

@implementation YdxinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdxinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdxinTableViewCell"];
    [cell setValueData:_dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ydxin *xin = _dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"pushYdwebViewControllerSegue" sender:xin];
}

- (void)getDataSource
{
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_home_eekstar Params:@{@"page":[NSString stringWithFormat:@"%ld",self.nowPage]} success:^(id json) {
        if ([self status:json]) {
            self.totalPage = [json[@"max"] integerValue];
            _dataSource = [NSMutableArray array];
            NSArray *ary = json[@"data"];
            for (NSDictionary *dic in ary) {
                NSError *error;
                Ydxin *xin = [[Ydxin alloc] initWithDictionary:dic error:&error];
                if (!error) {
                    [_dataSource addObject:xin];
                }
            }
            [_tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self showHint:@"获取失败"];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdwebViewController class]]) {
        YdwebViewController *webvc = (YdwebViewController *)vc;
        webvc.xinInfo = sender;
    }
    
}


@end
