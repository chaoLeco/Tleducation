//
//  YdPayViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/18.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
@interface YdPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblsubtitle;
@property (strong,nonatomic) NSString *orderid;
@property (strong,nonatomic) NSString *payurl;
@end

@implementation YdPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotificationCenter addObserver:self selector:@selector(goback:) name:@"Yd_pay_popView" object:nil];
    if (_detail) {
        _orderid = _detail.orderid;
        _lblTitle.text = [NSString stringWithFormat:@"订单-%@",_detail.orderid];
        _lblsubtitle.text = [NSString stringWithFormat:@"%@-￥%@",_detail.productname,_detail.sum];
        _payurl = Yd_pay_ali;
    }
    if (_vipOrder) {
        _orderid = _vipOrder.orderid;
        _lblTitle.text = [NSString stringWithFormat:@"订单-%@",_vipOrder.orderid];
        _lblsubtitle.text = [NSString stringWithFormat:@"购买会员-%@月-￥%@",_vipOrder.moon,_vipOrder.sum];
        _payurl = Yd_pay_alivip;
    }
}

- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    if ([sender isKindOfClass:[NSString class]]) {
        [self showHint:sender];
    }
}

- (IBAction)gopay:(id)sender {
    
    [XCNetworking XC_GET_JSONDataWithUrl:_payurl Params:@{@"orderid":_orderid} success:^(id json) {
        if ([self status:json]) {

            [[AlipaySDK defaultService] payOrder:json[@"data"] fromScheme:@"yd.Tleducation" callback:^(NSDictionary *resultDic) {
                NSLog(@"%@",resultDic);
            }];
        }
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
