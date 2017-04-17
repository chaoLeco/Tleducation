//
//  YdLoginPwViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/13.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdLoginPwViewController.h"

@interface YdLoginPwViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation YdLoginPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if ([_txtPhone.text isMatchingRegularEpressionByPattern:RE_MobileNumber]) {
        if ([_txtPassword.text isMatchingRegularEpressionByPattern:RE_SecretLeast(6,15)]) {
            [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_Login_password
                                          Params:@{@"usertel":_txtPhone.text,
                                                   @"password":_txtPassword.text}
                                         success:^(id json) {
                                             if ([self status:json]) {
                                                 k_SET_OBJECT(json[@"data"][@"userid"], Yd_user);
                                                 [self showHint:@"登陆成功"];
                                                 [kNotificationCenter postNotificationName:Yd_Notification_login object:nil];
                                                 [self dismissAction:nil];
                                             }else
                                                 [self showHint:@"登录失败"];
                                          }
                                            fail:^(NSError *error) {
                                              [self showHint:@"登录失败"];
                                          }];
            
        }else
            [self showHint:@"请输入6~15密码"];
    }else
        [self showHint:@"请正确输入手机号"];
    
}

- (IBAction)dismissAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    self.navigationController.navigationBar.alpha = 1;
}


@end
