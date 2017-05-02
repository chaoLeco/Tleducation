//
//  YdListViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdListViewController.h"
#import "YdhomeListTableViewCell.h"
@interface YdListViewController ()

@end

@implementation YdListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _ch.st;
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
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdhomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdhomeListTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushYdListDetalisViewControllerSegue" sender:self.navigationItem.title];
}

- (void)getDataSource
{
//    [XCNetworking XC_GET_JSONDataWithUrl:<#(NSString *)#> Params:<#(NSDictionary *)#> success:<#^(id json)success#> fail:<#^(NSError *error)faill#>]
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
