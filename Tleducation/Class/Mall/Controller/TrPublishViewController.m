//
//  TrPublishViewController.m
//  Tourism_Tr
//
//  Created by lecochao on 2017/3/24.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "TrPublishViewController.h"
#import "LsChooseImg.h"
#import "ZLPhoto.h"
#import "KZVideoViewController.h"
#import "KZVideoPlayer.h"
#import "OrderPickerView.h"

@interface TrPublishViewController ()<KZVideoViewControllerDelegate>
{
    KZVideoModel *_videoModel;
}
@property (weak, nonatomic) IBOutlet UILabel *lblplaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet LsChooseImg *tableImg;
@property (weak, nonatomic) IBOutlet UIView *videoBgView;

@property (strong,nonatomic) NSMutableArray *chooseImage;
@end

@implementation TrPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choicePicAction:(UIButton *)sender {
    
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alter addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
        videoVC.delegate = self;
        [videoVC startAnimationWithType:KZVideoViewShowTypeSmall];
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //选图片
        [self photoSelectetPostImg];
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alter animated:YES completion:nil];
}
- (IBAction)backAction:(id)sender {
    [_textView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postDynamic:(id)sender {
    
    NSString *userid = k_GET_OBJECT(Yd_user);
    if (![self isLogin]) {
        return;
    }
    [self showHUDWithHint:nil];
    if (_chooseImage.count>0) {
        NSMutableArray *ary = [NSMutableArray array];
        for (UIImage *img in _chooseImage) {
            [ary addObject:@{@"picKey":@"file[]",@"picData":UIImagePNGRepresentation(img)}];
        }
        NSString *str = _textView.text.length>0?_textView.text:@"分享图片...";
        [XCNetworking XC_Post_UploadWithUrl:Yd_Url_dy_posttrend Params:@{@"userid":userid,@"title":str} Data_arr:ary success:^(id responseObject) {
            if ([self status:responseObject]) {
                NSLog(@"发布成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self hideHud];
        } fail:^(NSError *error) {
            NSLog(@"发布失败！");
            [self hideHud];
        }];
    } else
    if (_videoModel) {
        NSString *str = _textView.text.length>0?_textView.text:@"分享视频...";
        [XCNetworking XC_Post_VideoWithUrl:Yd_Url_dy_posttrend Params:@{@"userid":userid,@"title":str} videoPath:_videoModel.videoAbsolutePath success:^(id responseObject) {
            if ([self status:responseObject]) {
                NSLog(@"发布成功");
                [self removeVideo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self hideHud];
        } fail:^(NSError *error) {
            NSLog(@"发布失败！");
            [self hideHud];
        }];
    }else{
        if (_textView.text.length>0) {
            [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_posttrend Params:@{@"userid":userid,@"title":_textView.text} success:^(id json) {
                if ([self status:json]) {
                    NSLog(@"发布成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [self hideHud];
            } fail:^(NSError *error) {
                NSLog(@"发布失败！");
                [self hideHud];
            }];
        }else
            [self showHint:@"请输入分享内容"];
    }
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
        photo.toView = cell.imgView;
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


#pragma mark - KZVideoViewControllerDelegate
- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel {
    _videoModel = videoModel;
    
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attri = [fm attributesOfItemAtPath:_videoModel.videoAbsolutePath error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }
    else {
        NSLog(@"视频总大小:%.0fKB",attri.fileSize/1024.0);
    }
    
    for (UIView *subview in _videoBgView.subviews) {
        if (![subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    _videoBgView.hidden = NO;
    UIImageView *img = [[UIImageView alloc]initWithFrame:_videoBgView.bounds];
    img.image = [UIImage imageWithContentsOfFile:_videoModel.thumAbsolutePath];
    [_videoBgView addSubview:img];
    NSURL *videoUrl = [NSURL fileURLWithPath:_videoModel.videoAbsolutePath];
    KZVideoPlayer *player = [[KZVideoPlayer alloc] initWithFrame:_videoBgView.bounds videoUrl:videoUrl];
    [_videoBgView addSubview:player];
    [_videoBgView bringSubviewToFront:[_videoBgView viewWithTag:100]];
}
- (void)videoViewControllerDidCancel:(KZVideoViewController *)videoController {
    NSLog(@"没有录到视频");
}

- (IBAction)removeVideo:(id)sender {
    _videoBgView.hidden = YES;
    for (UIView *subview in _videoBgView.subviews) {
        if (![subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    _videoModel = nil;
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
        _lblplaceholder.text = @"此刻，想说些什么...";
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length<1) {
        _lblplaceholder.text = @"此刻，想说些什么...";
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
        _lblplaceholder.text = @"此刻，想说些什么...";
    }
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
