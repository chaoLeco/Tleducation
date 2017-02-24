//
//  YdxinViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdxinViewController.h"
#import "YdxinTableViewCell.h"
@interface YdxinViewController ()

@end

@implementation YdxinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdxinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdxinTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushYdwebViewControllerSegue" sender:self.navigationItem.title];
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
