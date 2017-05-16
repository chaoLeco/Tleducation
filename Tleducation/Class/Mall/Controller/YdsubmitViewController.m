//
//  YdsubmitViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/19.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdsubmitViewController.h"
#import "YdUser.h"
#import "YdOrderDetail.h"
#import "YdOrderDetailViewController.h"

@interface YdsubmitViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *proimg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPirce;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong,nonatomic) YdUser *userInfo;
@property (strong,nonatomic) YdOrderDetail *detail;
@end

@implementation YdsubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitAction:(id)sender {
    [self.view endEditing:YES];
    if (_txtName.text.length>1) {
        if ([_txtPhone.text isMatchingRegularEpressionByPattern:RE_MobileNumber]) {
            [self postOrder];
        }else [self showHint:@"请正确输入手机号"];
    }else [self showHint:@"请输入姓名"];
}

- (void)getUserData
{
    _lblTitle.text = _product.productname;
    [_proimg sd_setImageWithURL:[NSURL URLWithString:[Yd_Url_base stringByAppendingString:_product.pimg]] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
    if ([self isLogin]) {
        NSString *userid = k_GET_OBJECT(Yd_user);
        [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_User_info Params:@{@"userid":userid} success:^(id json) {
            if ([self status:json]) {
                NSError *error;
                _userInfo = [[YdUser alloc] initWithDictionary:json[@"data"] error:&error];
                _txtName.text = _userInfo.nickname;
                _txtPhone.text = _userInfo.usertel;
                if (!error) {
                    if ([_userInfo.vip intValue]==1) {
                        _lblPirce.text = _product.member_price;
                    }else
                        _lblPirce.text = _product.price;
                }
            }else
                [self showHint:@"好想出错了😳"];
        } fail:^(NSError *error) {
            [self showHint:@"网络错误"];
        }];
    }
}

- (void)postOrder
{
    if ([self isLogin]) {
        [self showHUDWithHint:nil];
        NSString *userid = k_GET_OBJECT(Yd_user);
        NSDictionary *dic = @{@"storeid":_product.storeid,@"productid":_product.productid,
                              @"userid":userid,@"pname":_txtName.text,
                              @"pphone":_txtPhone.text,@"sum":_lblPirce.text};
        [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_mall_submit Params:dic success:^(id json) {
            if ([self status:json]) {
                NSError *error;
                _detail = [[YdOrderDetail alloc] initWithDictionary:json[@"data"] error:&error];
                if (!error) {
                    [self performSegueWithIdentifier:@"pushYdOrderDetailViewController" sender:nil];
                }
                [self hideHud];
            }
        } fail:^(NSError *error) {
            [self showHint:@"提交失败"];
            [self hideHud];
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
        
        YdOrderDetailViewController  *detailvc = (
                                                  YdOrderDetailViewController *)vc;
        detailvc.detail = _detail;
    }
}


@end
