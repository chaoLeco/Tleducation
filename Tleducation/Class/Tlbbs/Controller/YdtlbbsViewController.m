//
//  YdtlbbsViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/2/23.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "LsDynamicDetailsViewController.h"
#import "YdtlbbsViewController.h"
#import "LsDynamicTableViewCell.h"
#import "NSString+Emoji.h"
#import "STInputBar.h"
#import "ZLPhoto.h"
NSString *const dynamicCellID_normal = @"LsDynamicTableViewCell_Normal";
NSString *const dynamicCellID_Picture = @"LsDynamicTableViewCell_Picture";
NSString *const dynamicCellID_Pictures = @"LsDynamicTableViewCell_Pictures";
NSString *const dynamicCellID_Pictures_6 = @"LsDynamicTableViewCell_Pictures_6";
NSString *const dynamicCellID_Video = @"LsDynamicTableViewCell_Video";
@interface YdtlbbsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) STInputBar *inputBar;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) NSString *dynamicmdid;/**< 将要被评论动态id*/
@end

@implementation YdtlbbsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 200.f;
    _tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(STInputBar *)inputBar
{
    if (!_inputBar) {
        _inputBar = [STInputBar inputBar];
        _inputBar.hidden = YES;
        _inputBar.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)-CGRectGetHeight(_inputBar.bounds)/2);
        [_inputBar setFitWhenKeyboardShowOrHide:YES];
        _inputBar.placeHolder = @"发布评论";
        
        kWeakSelf(self)
        [_inputBar setDidSendClicked:^(NSString *text) {
            weakself.inputBar.placeHolder = @"发布评论";
            weakself.inputBar.hidden = YES;
            NSLog(@"发送_%f_%@",CGRectGetHeight(weakself.inputBar.bounds),text);
//            [weakself postCommentInfo:text];
            [weakself.inputBar resignFirstResponder];
        }];
        [_inputBar setInputBarSizeChangedHandle:^{}];
    }
    return _inputBar;
}

#pragma mark - table -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LsDynamicModel *dy = _dataSource[indexPath.row];
    
    NSString *identifier = [self cellIdentifier:indexPath.row%5];
    identifier = [identifier isEqualToString:dynamicCellID_Pictures_6]?dynamicCellID_Pictures:identifier;
    LsDynamicTableViewCell_Normal *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
//    [cell setValueData:dy];
    cell.block =^(LsDynamicClickStyle style , id model ,id sender){
//        [self tableCellBlock:style Data:model ID:sender];
    };
    return cell;
}

- (NSString *)cellIdentifier:(NSInteger)n
{
    NSArray *array = @[dynamicCellID_normal,dynamicCellID_Picture,dynamicCellID_Pictures,dynamicCellID_Pictures_6,dynamicCellID_Video];
    return array[n];
}

//- (NSString *)cellIdentifierForModel:(LsDynamicModel *)dy
//{
//    if ([dy.mb_format isEqualToString:@"1"]) {
//        return dynamicCellID_normal;
//    }
//    if ([dy.mb_format isEqualToString:@"2"]) {
//        NSArray *array = [dy.mb_dynamic_img componentsSeparatedByString:@","];
//        if (array.count==1) {
//            return dynamicCellID_Picture;
//        }else if (array.count==6) {
//            return dynamicCellID_Pictures_6;
//        }else if (array.count<=3) {
//            return dynamicCellID_Pictures;
//        }else
//            return dynamicCellID_Pictures_6;
//    }
//    if ([dy.mb_format isEqualToString:@"3"]) {
//        return dynamicCellID_Video;
//    }
//    return nil;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_inputBar resignFirstResponder];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"pushDynamicDetailsStoryboardSegue" sender:cell.reuseIdentifier];
}

- (void)tableCellBlock:(LsDynamicClickStyle)style Data:(id)model ID:(id)sender
{
    switch (style) {
        case LsDynamicClickStyleUser:
            [self performSegueWithIdentifier:@"pushUserInfoStoryboardSegue" sender:model];
            break;
        case LsDynamicClickStylePicture1:
            NSLog(@"cell__pic__1");
//            [self lockChooseImg:1 dynamic:model.mb_dynamic_img ID:sender];
            break;
        case LsDynamicClickStylePicture2:
            NSLog(@"cell__pic__2");
//            [self lockChooseImg:2 dynamic:model.mb_dynamic_img ID:sender];
            break;
        case LsDynamicClickStylePicture3:
            NSLog(@"cell__pic__3");
//            [self lockChooseImg:3 dynamic:model.mb_dynamic_img ID:sender];
            break;
        case LsDynamicClickStyleVideo:
            NSLog(@"cell__Video__");
//            [self playVoideWith:model.mb_dynamic_voide];
            break;
        case LsDynamicClickStyleLeftBtn:
            NSLog(@"cell__btn__left");
            [_inputBar resignFirstResponder];
//            [self postDynamicThing:sender Data:model];
            break;
        case LsDynamicClickStyleRightBtn:
            NSLog(@"cell__btn__Right");
            _inputBar.hidden = NO;
//            _dynamicmdid = model.md_id;
            [_inputBar becomeFirstResponder];
            break;
        case LsDynamicClickStyleLocationBtn:
            NSLog(@"cell__Location__");
            break;
            
        default:
            break;
    }
}

- (void)lockChooseImg:(NSInteger)nn dynamic:(NSString *)imgStr ID:(id)sender
{
    
    NSArray *array = [imgStr componentsSeparatedByString:@","];
    NSMutableArray *assets = [NSMutableArray array];
    switch (array.count) {
        case 0:
            NSLog(@"错误 没有图片");
            break;
        case 1:{
            LsDynamicTableViewCell_Picture *view = (LsDynamicTableViewCell_Picture*)sender;
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:view.imgOnly.image];
            photo.toView = view.imgOnly;
            [assets addObject:photo];
        }
            break;
        default:{
            //            LsDynamicTableViewCell_Pictures_6 *view = (LsDynamicTableViewCell_Pictures_6*)sender;
            for (NSString *imgStr in array) {
//                NSString *imgUrl = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,imgStr];
                ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:@""];
                [assets addObject:photo];
            }
        }
            break;
    }
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 数据源/delegate
    pickerBrowser.editing = NO;
    pickerBrowser.photos = assets;
    // 当前选中的值
    pickerBrowser.currentIndex = nn-1;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[LsDynamicDetailsViewController class]]) {
        LsDynamicDetailsViewController *dydetails = [segue destinationViewController];
        dydetails.cellIdentifier = sender;
    }
}


@end
