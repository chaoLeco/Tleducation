//
//  YdOrderDetailViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/19.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdOrderDetailViewController.h"
#import "YdPayViewController.h"
#import "YdtlmallModel.h"
#import <MapKit/MapKit.h>
@interface YdOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *proimg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPirce;
@property (weak, nonatomic) IBOutlet UILabel *lblpayStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblorderid;
@property (weak, nonatomic) IBOutlet UILabel *lblstoreaddr;
@property (weak, nonatomic) IBOutlet UILabel *lblstorename;
@property (weak, nonatomic) IBOutlet UILabel *lblstoretel;
@property (weak, nonatomic) IBOutlet UILabel *lblpname;
@property (weak, nonatomic) IBOutlet UILabel *lblpphone;
@property (weak, nonatomic) IBOutlet UILabel *lblordertime;
@property (weak, nonatomic) IBOutlet UIButton *ordercode;

@property (weak, nonatomic) IBOutlet UIView *orderStateView;
@property (weak, nonatomic) IBOutlet UILabel *lblstate;
@end

@implementation YdOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showInfo];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSource];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showInfo
{
    if (_detail) {
        
        _lblTitle.text = _detail.productname;
        _lblPirce.text = _detail.sum;
        [_ordercode setTitle:_detail.ordercode forState:UIControlStateSelected];
        if ([_detail.pay_status intValue]==0) {
            _lblpayStatus.text = @"未支付";
            [self.view viewWithTag:100].hidden = NO;
            _orderStateView.hidden = YES;
        }else {
            [self.view viewWithTag:100].hidden = YES;
            _lblpayStatus.text = @"已支付";
            if ([_detail.order_status intValue]==1) {
                _lblpayStatus.text = @"订单--已完成";
                _orderStateView.hidden = YES;
            }else{
                _lblstate.text = @"未取货";
                _orderStateView.hidden = NO;
            }
            
        }
        _lblorderid.text = _detail.orderid;
        _lblstoreaddr.text = _detail.storeaddr;
        _lblstorename.text = _detail.storename;
        _lblstoretel.text = _detail.storetel;
        _lblpname.text = _detail.pname;
        _lblpphone.text = _detail.pphone;
        _lblordertime.text = [NSString stringDateFromString:_detail.ordertime];
        
        if (_detail.productimg) {
            [_proimg sd_setImageWithURL:[NSURL URLWithString:[Yd_Url_base stringByAppendingString:_detail.productimg]] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
        }
    }
}

- (void)getDataSource
{
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_User_order Params:@{@"orderid":_detail.orderid} success:^(id json) {
        if ([self status:json]) {
            NSError *error;
             _detail = [[YdOrderDetail alloc] initWithDictionary:json[@"data"] error:&error];
            if (!error) {
                [self showInfo];
            }
        }
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
    }];
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)lookordercode:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

- (IBAction)navigateAction:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_detail.lat floatValue],[_detail.lng floatValue]);
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    toLocation.name = self.title;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];

}

- (IBAction)tellAction:(id)sender {
    
    if ([_detail.storetel isMatchingRegularEpressionByPattern:RE_IsNumber]) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"是否拨打"                                                                             message: _detail.storetel                                                                       preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *telURL = [NSString stringWithFormat:@"telprompt://%@",_detail.storetel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURL]];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController: alertController animated: YES completion: nil];
    }else
        [self showHint:@"无法拨打该号码"];
}

- (IBAction)pickupAction:(id)sender {
    //确认收货
    if (![self isLogin]) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"确认已拿到'%@',如有问题请自行联系商家",_detail.productname];
    WGAlertView *alert = [[WGAlertView alloc] initWithTitle:@"确认收货" message:msg block:^(NSInteger buttonIndex, WGAlertView *alert_) {
        if (buttonIndex == 0) {
            [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_User_orderPickup Params:@{@"orderid":_detail.orderid} success:^(id json) {
                if ([self status:json]) {
                    _detail.order_status = @"1";
                    [self showInfo];
                }
            } fail:^(NSError *error) {
                [self showHint:@"确认收货失败"];
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdPayViewController class]]) {
        YdPayViewController *payvc = [segue destinationViewController];
        payvc.detail = _detail;
    }
}


@end
