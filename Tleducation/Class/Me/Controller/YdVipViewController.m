//
//  YdVipViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/18.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdVipViewController.h"
#import "YdPayViewController.h"
#import "Ydvip.h"
@interface YdVipViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imgVip;
@property (weak, nonatomic) IBOutlet UILabel *lbltxt;
@property (weak, nonatomic) IBOutlet UILabel *lblnum;
@property (weak, nonatomic) IBOutlet UILabel *lblsum;
@property (weak, nonatomic) IBOutlet UILabel *lblprice;

@property (assign,nonatomic) NSInteger num;
@property (strong,nonatomic) NSString *price;
@end

@implementation YdVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _num = 1;
    _price = @"0";
    _lblnum.text = @"1";
    _imgVip.hidden = YES;
    _headerPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]];
    if (_info) {
        NSString *url  = [Yd_Url_base stringByAppendingString:_info.headimg];
        [_headerPic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]]];
        _lblPhone.text = _info.usertel;
        if ([_info.vip intValue]==1) {
            _imgVip.hidden = NO;
            _lbltxt.text = [NSString stringWithFormat:@"%@\n到期",[NSString stringDateFromString:_info.exp]];
        }else _lbltxt.text = nil;
        _lblprice.text = [NSString stringWithFormat:@"会员**元/月"];
    }
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_vip_getfee Params:@{@"moon":@"1"} success:^(id json) {
        if ([self status:json]) {
            _price = json[@"data"][@"fee"];
            _lblprice.text = [NSString stringWithFormat:@"会员%@元/月",_price];
            [self delAction:nil];
        }
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
    }];
    [self delAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)delAction:(id)sender {
    if (--_num<1) {
        _num = 1;
    }
    _lblnum.text = [NSString stringWithFormat:@"%ld",(long)_num];
    _lblsum.text = [NSString stringWithFormat:@"￥%.2f",_num*[_price floatValue]];
}

- (IBAction)addAction:(id)sender {
    if (++_num>99) {
        _num = 99;
    }
    _lblnum.text = [NSString stringWithFormat:@"%ld",(long)_num];
    _lblsum.text = [NSString stringWithFormat:@"￥%.2f",_num*[_price floatValue]];
}

- (IBAction)payAction:(id)sender {
    
    if ([_price floatValue]==0) {
        return [self showHint:@"未能获得vip单价"];
    }
    if (![self isLogin]) {
        return;
    }
    NSString *userid = k_GET_OBJECT(Yd_user);
    
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_vip_buyvip Params:@{@"userid":userid,@"moon":[NSString stringWithFormat:@"%ld",_num]} success:^(id json) {
        if ([self status:json]) {
            NSError *error;
            Ydvip *vipOrder = [[Ydvip alloc]initWithDictionary:json[@"data"] error:&error];
            if (!error) {
              [self performSegueWithIdentifier:@"pushYdPayViewController" sender:vipOrder];
            }else [self showHint:@"( ⊙ o ⊙ )！出错了！"];
        }else [self showHint:@"( ⊙ o ⊙ )！出错了！"];
    } fail:^(NSError *error) {
        [self showHint:@"网络错误，请重试"];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdPayViewController class]]) {
        YdPayViewController *ydpay = (YdPayViewController *)[segue destinationViewController];
        ydpay.vipOrder = sender;
    }
}


@end
