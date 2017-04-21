//
//  LsPublishDynamicViewController.m
//  lushangjituan
//
//  Created by Chaos on 16/8/27.
//  Copyright © 2016年 gansu. All rights reserved.
//
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "LsPublishDynamicViewController.h"
#import "LsLocationChooseViewController.h"
#import "PKRecordShortVideoViewController.h"
#import "LsVideoPlayView.h"
#import "LsChooseImg.h"
#import "ZLPhoto.h"
#import "NSString+Emoji.h"

@interface LsPublishDynamicViewController ()
<UIActionSheetDelegate,
PKRecordShortVideoDelegate,
BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblplaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet LsVideoPlayView *videoView;
@property (weak, nonatomic) IBOutlet LsChooseImg *tableImg;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (strong,nonatomic) NSMutableArray *chooseImage;/**< 选中的照片*/
@property (strong,nonatomic) NSString *outputFilePath;/**< 视频路径*/
@property(strong, nonatomic) BMKLocationService *locService;
@property(strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;
@property(strong, nonatomic) NSString *locationStr;/**< 位置信息*/
@property(strong, nonatomic) BMKReverseGeoCodeResult *result;/**< 定位位置信息*/
@property(nonatomic, assign) CLLocationCoordinate2D locationPoint;/**< 位置loc*/
@property(nonatomic, assign) NSInteger locationRow;/**< 位置loc.row*/
@end

@implementation LsPublishDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoView.alpha = 0;
    _tableImg.alpha = 0;
    _tableImg.block_addImg =^(NSInteger nn){[self photoSelectetPostImg];};
    _tableImg.block_lockImg=^(NSInteger nn){[self lockChooseImg:nn];};
    _tableImg.block_removeImg= ^(NSInteger nn){
        [_chooseImage removeObjectAtIndex:nn];
        if (_chooseImage.count ==0) {
            [UIView animateWithDuration:0.2 animations:^{
                _tableImg.alpha = 0;
            }];
        }
    };
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
-(void)viewWillDisappear:(BOOL)animated
{
    _geoCodeSearch.delegate = nil;
    _locService.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action -

- (IBAction)publishMsgAction:(id)sender {
    
    //发布
    //需要处理 发送问题（后台） 动态及时显示问题 要存入db中
    // 备注 由于动态ID 未知 无法存入
    [_textView resignFirstResponder];
    if (_chooseImage.count>0) {
        [self postImgDynamicInfo];
    }else if (_outputFilePath){
        [self postVideoDynamicInfo];
    }else [self postInfoDynamicInfo];
    
    
}
- (IBAction)choicePicAction:(id)sender {
    //选图片
    
    [self photoSelectetPostImg];
    
}


- (void)photoSelectetPostImg
{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 6-_tableImg.data.count;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
//        NSMutableArray *thumbImageArray = [NSMutableArray array];
        _chooseImage = [NSMutableArray arrayWithArray:_tableImg.data];
        for (ZLPhotoAssets *photo in status) {
            if ([photo isKindOfClass:[ZLPhotoAssets class]]) {
                [_chooseImage addObject:photo.thumbImage];
            }
            if ([photo isKindOfClass:[UIImage class]]) {
                [_chooseImage addObject:photo];
            }
        }
        _tableImg.data = _chooseImage.copy;
        [_tableImg reloadData];
    };
    [pickerVc showPickerVc:self];
    NSLog(@"_____________________");
}

- (void)lockChooseImg:(NSInteger)nn
{
    NSLog(@"___________");
    NSMutableArray *assets = [NSMutableArray array];
    for (int i=0; i<_chooseImage.count; i++) {
        ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:_chooseImage[i]];
        LsChooseImgTableCell *cell = [_tableImg cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        photo.toView = cell.img;
        [assets addObject:photo];
    }
    NSLog(@"___________");
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
     pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 数据源/delegate
    pickerBrowser.editing = NO;
    pickerBrowser.photos = assets;
    // 能够删除
//    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = nn;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
    NSLog(@"___________");
}

- (IBAction)choiceVideo:(id)sender {
    // 选视频
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [NSProcessInfo processInfo].globallyUniqueString;
    NSString *path = [paths[0] stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"mp4"]];
    NSLog(@"%@",path);
    //跳转默认录制视频ViewController
    PKRecordShortVideoViewController *viewController = [[PKRecordShortVideoViewController alloc] initWithOutputFilePath:path outputSize:CGSizeMake(320, 240) themeColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1]];
    //通过代理回调
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - TextFieldDelegate -

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.text.length>0) {
        _lblplaceholder.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length<1) {
         _lblplaceholder.text = @"分享你的新鲜事...";
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length<1) {
        _lblplaceholder.text = @"分享你的新鲜事...";
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (text.length>0) {
        _lblplaceholder.text = @"";
    }
    if (text.length == 0 &textView.text.length==1) {
        _lblplaceholder.text = @"分享你的新鲜事...";
    }
    return YES;
}

#pragma mark - PKRecordShortVideoDelegate -
//视频拍摄完成
- (void)didFinishRecordingToOutputFilePath:(NSString *)outputFilePath {
   NSLog(@"%@",outputFilePath);
    _outputFilePath = outputFilePath;
    [_videoView setVideoPath:outputFilePath];
    [UIView animateWithDuration:0.2 animations:^{
        _videoView.alpha = 1;
    }];
    _videoView.removeBlock = ^{ _outputFilePath = nil;};
}

#pragma mark - Location -

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation) {
        [_locService stopUserLocationService];
        [self cityGeoCodeSearch:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
    }
}

- (void)cityGeoCodeSearch:(CLLocationCoordinate2D)pt
{
    _locationPoint = pt;
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];;
    _geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = _locationPoint;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        _result = result;
        _locationStr = result.addressDetail.city;
        [_locationBtn setTitle:_locationStr forState:UIControlStateNormal];
        _locationRow = 1;//定位成功后 默认选择当前城市
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


#pragma mark - Navigation -

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destinationViewController = [segue destinationViewController];
    if ([destinationViewController isKindOfClass:[LsLocationChooseViewController class]]) {
        LsLocationChooseViewController *locvc = (LsLocationChooseViewController *)destinationViewController;
        locvc.result = _result;
        locvc.chooseRow = _locationRow;
        WEAKOBJECT(locvc, selflocvc)
        locvc.block = ^{
            _locationRow = selflocvc.chooseRow;
            switch (_locationRow) {
                case 0:
                    _locationStr = _result.addressDetail.city;
                    _locationPoint = _result.location;
                    [_locationBtn setTitle:_locationStr forState:UIControlStateNormal];
                    break;
                case 1:
                    _locationStr = nil;
                    _locationPoint = _result.location;
                    [_locationBtn setTitle:@"不显示位置" forState:UIControlStateNormal];
                    break;
                case 2:
                    _locationStr = _result.addressDetail.streetName;
                    _locationPoint = _result.location;
                    [_locationBtn setTitle:_locationStr forState:UIControlStateNormal];
                    break;
                default:{
                    BMKPoiInfo *info = _result.poiList[locvc.chooseRow-3];
                    _locationStr = info.name;
                    _locationPoint = info.pt;
                    [_locationBtn setTitle:_locationStr forState:UIControlStateNormal];
                }
                    break;
            }

        };
    }
}

- (IBAction)backSegueToLsPublishDynamicViewController:(UIStoryboardSegue *)segue {
    UIViewController *sourceViewController = segue.sourceViewController;
    NSLog(@"from %@ vc",[sourceViewController class]);
//    if ([sourceViewController isKindOfClass:[LsLocationChooseViewController class]]) {
//        LsLocationChooseViewController *locvc = (LsLocationChooseViewController *)sourceViewController;
//        
//    }
}


#pragma mark - 关于发布数据处理 -

/*!
 *  发视频
 */
- (void)postVideoDynamicInfo
{
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:token forKey:@"token"];
        [dic setObject:@"3" forKey:@"format"];
        if (_textView.text.length>0) {
            NSString *str = [_textView.text stringByReplacingEmojiUnicodeWithCheatCodes];
            [dic setObject:str forKey:@"dynamic_info"];
        }else [dic setObject:@"分享视频..." forKey:@"dynamic_info"];
        if (_locationStr) {
            [dic setObject:_locationStr forKey:@"cityname"];
            NSString *jingwei = [NSString stringWithFormat:@"%f,%f",_locationPoint.latitude,_locationPoint.longitude];
            [dic setObject:jingwei forKey:@"jingwei"];
        }
        [self showHUDWithHint:nil];
        [XCNetworking XC_Post_VideoWithUrl:Ls_PutDynamicComment Params:dic videoPath:_outputFilePath success:^(id responseObject) {
            if ([self status:responseObject[JOSNstatus]]) {
                [self showHint:@"动态发布成功"];
                [_videoView remove];//发布成功移除视频文件
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self hideHud];
        } fail:^(NSError *error) {
            [self showHint:@"动态发送失败"];
            [self hideHud];
        }];
    }else [self dealWithToken];
    
}

- (void)postImgDynamicInfo
{
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:token forKey:@"token"];
        [dic setObject:@"2" forKey:@"format"];
        if (_textView.text.length>0) {
            NSString *str = [_textView.text stringByReplacingEmojiUnicodeWithCheatCodes];
            [dic setObject:str forKey:@"dynamic_info"];
        }else [dic setObject:@"分享图片..." forKey:@"dynamic_info"];
        if (_locationStr) {
            [dic setObject:_locationStr forKey:@"cityname"];
            NSString *jingwei = [NSString stringWithFormat:@"%f,%f",_locationPoint.latitude,_locationPoint.longitude];
            [dic setObject:jingwei forKey:@"jingwei"];
        }
        NSMutableArray *datas = [NSMutableArray array];
        for (UIImage *img in _chooseImage) {
            NSData *picData = UIImageJPEGRepresentation(img,0.5);
            [datas addObject:@{@"picData":picData,@"picKey":@"file[]"}];
        }
        [self showHUDWithHint:nil];
        [XCNetworking XC_Post_UploadWithUrl:Ls_PutDynamicComment Params:dic Data_arr:datas success:^(id responseObject) {
            if ([self status:responseObject[JOSNstatus]]) {
                [self showHint:@"动态发布成功"];
                _chooseImage = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self hideHud];
        } fail:^(NSError *error) {
            [self showHint:@"动态发送失败"];
            [self hideHud];
        }];
    }else [self dealWithToken];


}

- (void)postInfoDynamicInfo
{
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:token forKey:@"token"];
        [dic setObject:@"1" forKey:@"format"];
        if (_textView.text.length>0) {
            NSString *str = [_textView.text stringByReplacingEmojiUnicodeWithCheatCodes];
            [dic setObject:str forKey:@"dynamic_info"];
        }else {
            [self showHint:@"🤕没有什么可分享的🤕"];
            return;
        };
        if (_locationStr) {
            [dic setObject:_locationStr forKey:@"cityname"];
            NSString *jingwei = [NSString stringWithFormat:@"%f,%f",_locationPoint.latitude,_locationPoint.longitude];
            [dic setObject:jingwei forKey:@"jingwei"];
        }
        [self showHUDWithHint:nil];
        [XCNetworking XC_Post_JSONWithUrl:Ls_PutDynamicComment parameters:dic success:^(id json) {
            if ([self status:json[JOSNstatus]]) {
                [self showHint:@"动态发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self hideHud];
        } fail:^(NSError *error) {
            [self showHint:@"动态发送失败"];
            [self hideHud];
        }];
    }else [self dealWithToken];
    
}
@end
