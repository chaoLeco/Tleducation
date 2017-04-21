//
//  YdVipViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/18.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdVipViewController.h"
#import "YdPayViewController.h"
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

@end

@implementation YdVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _num = 1;
    _lblnum.text = @"1";
    _imgVip.hidden = YES;
    _headerPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]];
    if (_info) {
        NSString *url  = [Yd_Url_base stringByAppendingString:_info.headimg];
        [_headerPic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]]];
        _lblPhone.text = _info.usertel;
        if ([_info.vip intValue]==1) {
            _imgVip.hidden = NO;
            _lbltxt.text = @"2017年04月18日12:12\n到期";
            [self getVipInfo];
        }
        _lblprice.text = @"会员15元/月";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)delAction:(id)sender {
    if (--_num<1) {
        _num = 1;
        return;
    }
    _lblnum.text = [NSString stringWithFormat:@"%ld",(long)_num];
    _lblsum.text = [NSString stringWithFormat:@"￥%ld.00",_num*15];
}

- (IBAction)addAction:(id)sender {
    if (++_num>99) {
        _num = 99;
        return;
    }
    _lblnum.text = [NSString stringWithFormat:@"%ld",(long)_num];
    _lblsum.text = [NSString stringWithFormat:@"￥%ld.00",_num*15];
}

- (IBAction)payAction:(id)sender {
    
    [self performSegueWithIdentifier:@"pushYdPayViewController" sender:nil];
}

- (void)getVipInfo
{
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
