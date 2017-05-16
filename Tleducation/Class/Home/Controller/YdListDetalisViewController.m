//
//  YdListDetalisViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdListDetalisViewController.h"
#import "YdListDeatlisTableViewCell.h"
#import "SDCycleScrollView.h"
#import "YdsubmitViewController.h"
#import <MapKit/MapKit.h>
#import "Ydprocom.h"
#import "NSDate+Category.h"

@interface YdListDetalisViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *banner;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UILabel *lbladdress;
@property (weak, nonatomic) IBOutlet UILabel *lblphone;
@property (weak, nonatomic) IBOutlet UILabel *lblprice;
@property (weak, nonatomic) IBOutlet UILabel *lblprice_m;

@property (strong ,nonatomic) NSMutableArray *datas;
@end

@implementation YdListDetalisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.estimatedRowHeight = 100.f;
    _tableview.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableview.estimatedSectionHeaderHeight = 30.f;
    _tableview.tableFooterView = [UIView new];
    self.cycleScrollView.localizationImageNamesGroup = @[@"zwt_lie"];
    [self updateInfo];
    [self getDataSource];
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_banner.bounds delegate:self placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
        [_banner addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callAction:(id)sender {
    if ([_model.storetel isMatchingRegularEpressionByPattern:RE_IsNumber]) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"是否拨打"                                                                             message: _model.storetel                                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *telURL = [NSString stringWithFormat:@"telprompt://%@",_model.storetel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURL]];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController: alertController animated: YES completion: nil];
    }else
        [self showHint:@"无法拨打该号码"];
}

- (IBAction)navAction:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.lat floatValue],[_model.lng floatValue]);
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    toLocation.name = self.title;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];

}
- (IBAction)procomAction:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"评论一下"                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"想说些什么";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self postprocom:alertController.textFields[0].text];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController: alertController animated: YES completion: nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YdListDeatlisTableSection *sectionView = [tableView dequeueReusableCellWithIdentifier:@"YdListDeatlisTableSection"];
    if (section==0) {
        sectionView.lbltitle.text = @"学校简介";
    }else
        sectionView.lbltitle.text = @"学校评价";
    return sectionView;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else
        return _datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        YdListDeatlisTableViewCell_title *cell = [tableView dequeueReusableCellWithIdentifier:@"YdListDeatlisTableViewCell_title"];
        cell.lblsubtitle.text = _model.productds;
        return cell;
    }else{
        YdListDeatlisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdListDeatlisTableViewCell"];
        Ydprocom *procom = _datas[indexPath.row];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Yd_Url_base,procom.headimg]]
                      placeholderImage:image];
        cell.lblname.text = procom.nickname;
        cell.lblsubtitle.text = procom.title;
        cell.lbltime.text = [procom.time stringDateWithFormat:@"yyyy-MM-dd HH:mm"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - SDCycleScrollViewDelegate -
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    NSLog(@"点击了第%ld个",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    //    NSLog(@"当前位置%ld",index);
}

- (void)updateInfo
{
    if (_model) {
        _lbltitle.text = _model.productname;
        _lbladdress.text = [NSString stringWithFormat:@"地址：%@",_model.storeaddr];
        _lblphone.text = [NSString stringWithFormat:@"联系电话：%@",_model.storetel];
        _lblprice.text = [NSString stringWithFormat:@"￥%@",_model.price];
        _lblprice_m.text = [NSString stringWithFormat:@"￥%@",_model.member_price];
        self.cycleScrollView.imageURLStringsGroup = @[[Yd_Url_base stringByAppendingString:_model.pimg]];
    }else
        [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_mall_productinfo Params:@{@"productid":_productid} success:^(id json) {
            if ([self status:json]) {
                NSError *error;
                _model = [[YdtlmallModel alloc]initWithDictionary:json[@"data"] error:&error];
                if (!error) {
                    [self updateInfo];
                    [_tableview reloadData];
                }
            }
        } fail:^(NSError *error) {
            [self showHint:@"网络错误"];
        }];
}

- (void)getDataSource
{
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_mall_procom Params:@{@"pid":_productid} success:^(id json) {
        if ([self status:json]) {
            _datas = [NSMutableArray array];
            NSArray *ary = json[@"data"];
            for (NSDictionary *dic in ary) {
                NSError *error;
                Ydprocom *model = [[Ydprocom alloc]initWithDictionary:dic error:&error];
                if (!error) {
                    [_datas addObject:model];
                }
            }
            [_tableview reloadData];
        }
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
    }];
}

- (void)postprocom:(NSString *)str
{
    if (![self isLogin]) {
        return;
    }
    NSString *uid = k_GET_OBJECT(Yd_user);
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_mall_post_procom
                                  Params:@{@"pid":_model.productid,
                                           @"title":str,
                                           @"uid":uid}
                              success:^(id json) {
        if ([self status:json]) {
            [self showHint:@"已评论"];
            [_tableview reloadData];
            [self getDataSource];
        }
    } fail:^(NSError *error) {
        [self showHint:@"评论失败"];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[YdsubmitViewController class]]) {
        YdsubmitViewController *submitvc = (YdsubmitViewController *)vc;
        submitvc.product = _model;
    }
}


@end
