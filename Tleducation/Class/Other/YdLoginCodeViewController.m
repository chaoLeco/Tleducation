//
//  YdLoginCodeViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/13.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdLoginCodeViewController.h"
#import "NSTimer+WGTimer.h"
@interface YdLoginCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCodePic;
@property (weak, nonatomic) IBOutlet UITextField *txtCodeMsg;
@property (weak, nonatomic) IBOutlet UIImageView *imgCode;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger seconds;

@property (strong,nonatomic) NSString *codePic;
@end

@implementation YdLoginCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCodepic:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTimer *)timer
{
    if (!_timer) {
       _timer = [NSTimer initWithTimeInterval:1 target:self selector:@selector(subtracter) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodepic:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",Yd_Url_User_CodePic,[self getAuthcode:4]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    _imgCode.image = [UIImage imageWithData:data];
}

- (IBAction)getCodeMsg:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([_txtPhone.text isMatchingRegularEpressionByPattern:RE_MobileNumber]) {
        if ([[_txtCodePic.text lowercaseString] isEqualToString:[_codePic lowercaseString]]) {
            [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_get_codeMsg Params:@{@"usertel":_txtPhone.text} success:^(id json) {
               if ([self status:json]) {
                   NSLog(@"data");
                   _seconds = 60;
                   sender.hidden = YES;
                   _lblTime.text = [NSString stringWithFormat:@"60s"];
                   [self.timer resume];
               }
           } fail:^(NSError *error) {
               [self showHint:@"获取失败"];
           }];
        }else
            [self showHint:@"请正确输入4位验证码"];
    }else
        [self showHint:@"请正确输入手机号"];
}

- (void)subtracter{
    
    if(--_seconds<1){
        [self.timer stop];
        [self.view viewWithTag:200].hidden = NO;
        return;
    }
    _lblTime.text = [NSString stringWithFormat:@"%lds",_seconds];
}

- (IBAction)loginAction:(id)sender {
    
    if (_txtCodeMsg.text.length>2) {
        [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_Login_codeMsg
                                      Params:@{@"usertel":_txtPhone.text,
                                               @"smscode":_txtCodeMsg.text}
                                     success:^(id json) {
                                         if ([self status:json]) {
                                             k_SET_OBJECT(json[@"data"][@"userid"], Yd_user);
                                             [self showHint:@"登陆成功"];
                                             [kNotificationCenter postNotificationName:Yd_Notification_login object:nil];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }
                                     }
                                        fail:^(NSError *error) {
                                            [self showHint:@"登录失败"];
                                        }];
    }else
        [self showHint:@"请正确输入验证码"];
    
}

- (NSString *)getAuthcode:(NSInteger)kCharCount
{
    //字符串素材
    NSArray *dataArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    
    NSMutableString *authCodeStr = [[NSMutableString alloc] initWithCapacity:kCharCount];
    //随机从数组中选取需要个数的字符串，拼接为验证码字符串
    for (int i = 0; i < kCharCount; i++)
    {
        NSInteger index = arc4random() % (dataArray.count-1);
        NSString *tempStr = [dataArray objectAtIndex:index];
        authCodeStr = (NSMutableString *)[authCodeStr stringByAppendingString:tempStr];
    }
    _codePic = authCodeStr;
    return authCodeStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
