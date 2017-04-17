//
//  YdSetPasswordViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/17.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdSetPasswordViewController.h"

@interface YdSetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;
@property (weak, nonatomic) IBOutlet UITextField *txtCodeMsg;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger seconds;
@end

@implementation YdSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMsgCode:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getMsgCode:(UIButton *)sender {
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_get_codeMsg Params:@{@"usertel":@"userPhone"} success:^(id json) {
        if ([self status:json]) {
            NSLog(@"data");
            _seconds = 60;
            sender.hidden = YES;
            _lblTime.text = [NSString stringWithFormat:@"60s"];
            [self.timer resume];
        }
    } fail:^(NSError *error) {
        [self showHint:@"获取失败"];
        [self.timer stop];
        sender.hidden = NO;
    }];
}


- (IBAction)saveAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([_txtpassword.text isMatchingRegularEpressionByPattern:RE_SecretLeast(6,15)]) {
        if (_txtCodeMsg.text.length>2) {
            [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_Login_codeMsg
                                          Params:@{@"usertel":@"",
                                                   @"smscode":@""}
                                         success:^(id json) {
                                             if ([self status:json]) {
                                                 
                                                 [self showHint:@"登陆成功"];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }
                                         }
                                            fail:^(NSError *error) {
                                                [self showHint:@"登录失败"];
                                            }];
        }else
            [self showHint:@"请正确输入验证码"];
    }else
        [self showHint:@"请输入6~15位密码"];
    
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer initWithTimeInterval:1 target:self selector:@selector(subtracter) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)subtracter{
    
    if(--_seconds<1){
        [self.timer stop];
        [self.view viewWithTag:200].hidden = NO;
        return;
    }
    _lblTime.text = [NSString stringWithFormat:@"%lds",_seconds];
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
