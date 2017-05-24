//
//  YdmeViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdmeViewController.h"
#import "YdUserInfoViewController.h"
#import "YdmeTableCell.h"
#import "YdVipViewController.h"
#import "YdUser.h"

@interface YdmeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *unLoginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *titles;
@property (strong,nonatomic) NSArray *icons;
@property (strong,nonatomic) YdUser *userInfo;
@property (strong,nonatomic) NSMutableArray *subTitles;

@end

@implementation YdmeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setTableFooterView:[UIView new]];
    [kNotificationCenter addObserver:self selector:@selector(logout) name:Yd_Notification_logout object:nil];
    [kNotificationCenter addObserver:self selector:@selector(login) name:Yd_Notification_login object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self login];
}

- (IBAction)vipAction:(id)sender {
    //会员vip
}

- (IBAction)loginACtion:(id)sender {
    //未登录
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"个人信息",@"会员中心",@"我的订单",@"关于我们"];
    }
    return _titles;
}

-(NSArray *)icons
{
    if (!_icons) {
        _icons = @[@"tlme",@"tl_Vip",@"tldingdan",@"tlaboutme"];
    }
    return _icons;
}

- (NSMutableArray *)subTitles
{
    if (!_subTitles) {
        _subTitles = [NSMutableArray arrayWithObjects:@"",@"",@"",@"" ,nil];
    }
    return _subTitles;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdmeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdmeTableCell"];
    cell.title.text = self.titles[indexPath.row];
    cell.icon.image = [UIImage imageNamed:self.icons[indexPath.row]];
    cell.subTitle.text = self.subTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"pushYdUserInfoViewController" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"pushYdVipViewController" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"pushYdUserOrderViewController" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"pushTrAboutmeViewController" sender:nil];
            break;
        default:
            break;
    }
    
}

- (void)logout
{
    k_REMOVE_OBJECT(Yd_user);
    _headPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]];
    _lblName.text = @"未登录";
    [_tableView viewWithTag:100].hidden = YES;
    [_tableView viewWithTag:101].hidden = NO;
}

- (void)login
{
    if ([self isLogin]) {
        NSString *userid = k_GET_OBJECT(Yd_user);
        [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_User_info Params:@{@"userid":userid} success:^(id json) {
            if ([self status:json]) {
                NSError *error;
                _userInfo = [[YdUser alloc] initWithDictionary:json[@"data"] error:&error];
                if (!error) {
                    NSString *url  = [Yd_Url_base stringByAppendingString:_userInfo.headimg];
                    [_headPic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]]];
                    _lblName.text = _userInfo.nickname?_userInfo.nickname:_userInfo.username;
                    if ([_userInfo.vip intValue]==1) {
                        [_tableView viewWithTag:100].hidden = NO;//会员
                    }else
                        [_tableView viewWithTag:100].hidden = YES;//会员
                    [_tableView viewWithTag:101].hidden = YES;
                    [self showInfo];
                    [_tableView reloadData];
                }
            }else
                [self showHint:@"好想出错了😳"];
        } fail:^(NSError *error) {
            [self showHint:@"网络错误"];
        }];
    }
}

- (void)showInfo
{
    if (!_userInfo.headimg||!_userInfo.nickname) {
        [self.subTitles removeObjectAtIndex:0];
        [self.subTitles addObject:@"资料不完整"];
    }
    if (!_userInfo.username||!_userInfo.nickname){
        _lblName.text = @"未设置昵称";
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdUserInfoViewController class]]) {
        YdUserInfoViewController *uservc = (YdUserInfoViewController *)vc;
        uservc.info = _userInfo;
    }
    if ([vc isKindOfClass:[YdVipViewController class]]) {
        YdVipViewController *vipvc = (YdVipViewController *)vc;
        vipvc.info = _userInfo;
    }
    
}


@end
