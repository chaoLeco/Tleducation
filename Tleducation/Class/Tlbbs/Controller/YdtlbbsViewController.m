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
#import "YdDynamic.h"

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
    [self tableRefresh:_tableView];
    [self.view addSubview:self.inputBar];
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
            [weakself postCommentInfo:text];
            [weakself.inputBar resignFirstResponder];
        }];
        [_inputBar setInputBarSizeChangedHandle:^{}];
    }
    return _inputBar;
}

#pragma mark - table -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdDynamic *dy = _dataSource[indexPath.row];
    NSString *identifier = [self cellIdentifierForModel:dy];
    identifier = [identifier isEqualToString:dynamicCellID_Pictures_6]?dynamicCellID_Pictures:identifier;
    LsDynamicTableViewCell_Normal *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setValueData:dy];
    cell.block =^(LsDynamicClickStyle style , id model ,id sender){
        if (style==LsDynamicClickStyleLeftBtn) {
            [self tableCellBlock:style Data:model ID:indexPath];
        }else
        [self tableCellBlock:style Data:model ID:sender];
    };
    return cell;
}

- (NSString *)cellIdentifierForModel:(YdDynamic *)dy
{
    if (dy.img.length>2) {
        NSArray *array = [dy.img componentsSeparatedByString:@","];
        if (array.count==1) {
            return dynamicCellID_Picture;
        }else if (array.count==6) {
            return dynamicCellID_Pictures_6;
        }else if (array.count<=3) {
            return dynamicCellID_Pictures;
        }else
            return dynamicCellID_Pictures_6;
    }else
    if (dy.video.length>1) {
        return dynamicCellID_Video;
    }else
        return dynamicCellID_normal;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_inputBar resignFirstResponder];
    [self performSegueWithIdentifier:@"pushDynamicDetailsStoryboardSegue" sender:indexPath];
}

- (void)tableCellBlock:(LsDynamicClickStyle)style Data:(YdDynamic *)model ID:(id)sender
{
    switch (style) {
//        case LsDynamicClickStyleVideo:
//            NSLog(@"cell__Video__");
//            //            [self playVoideWith:model.mb_dynamic_voide];
//            break;
//        case LsDynamicClickStyleUser:
//            [self performSegueWithIdentifier:@"pushUserInfoStoryboardSegue" sender:model];
//            break;
//        case LsDynamicClickStyleLocationBtn:
//            NSLog(@"cell__Location__");
//            break;
            
        case LsDynamicClickStylePicture1:
            NSLog(@"cell__pic__1");
            [self lockChooseImg:1 dynamic:model.img ID:sender];
            break;
        case LsDynamicClickStylePicture2:
            NSLog(@"cell__pic__2");
            [self lockChooseImg:2 dynamic:model.img ID:sender];
            break;
        case LsDynamicClickStylePicture3:
            NSLog(@"cell__pic__3");
            [self lockChooseImg:3 dynamic:model.img ID:sender];
            break;
        case LsDynamicClickStyleLeftBtn:
            NSLog(@"cell__btn__left");
            [self.inputBar resignFirstResponder];
            [self postDynamicThingData:model nn:[(NSIndexPath *)sender row]];
            break;
        case LsDynamicClickStyleRightBtn:
            NSLog(@"cell__btn__Right");
            self.inputBar.hidden = NO;
            _dynamicmdid = model.trendid;
            [self.inputBar becomeFirstResponder];
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
            for (NSString *imgStr in array) {
                NSString *imgUrl = [NSString stringWithFormat:@"%@%@",Yd_Url_base,imgStr];
                ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imgUrl];
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


-(void)getDataSource
{
    [self showHUDWithHint:nil];
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_trendList Params:@{@"page":[NSString stringWithFormat:@"%ld",self.nowPage]} success:^(id json) {
        if ([self status:json]) {
            if (self.nowPage ==1) {
                _dataSource = [NSMutableArray array];
            }
            self.totalPage = [json[@"max"] integerValue];
            NSArray *array = json[@"data"];
            for (NSDictionary *dic in array) {
                NSError *error;
                YdDynamic *dy = [[YdDynamic alloc]initWithDictionary:dic error:&error];
                if (!error) {
                    [_dataSource addObject:dy];
                }
            }
            [_tableView reloadData];
        }
        [self hideHud];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self hideHud];
        [self showHint:@"获取失败"];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)postCommentInfo:(NSString *)txt
{
    if (![self isLogin]) {
        return;
    }
    NSString *uid = k_GET_OBJECT(Yd_user);
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_trendPostComment Params:@{@"tid":_dynamicmdid,@"uid":uid,@"title":txt} success:^(id json) {
        if ([self status:json]) {
            [self showHint:@"评论成功"];
        }
    
    } fail:^(NSError *error) {
        [self showHint:@"评论失败"];
    }];
}

- (void)postDynamicThingData:(YdDynamic *)data nn:(NSInteger)row
{
    [XCNetworking  XC_GET_JSONDataWithUrl:Yd_Url_dy_del_add_ilike Params:@{@"tid":data.trendid} success:^(id json) {
        if ([self status:json]) {
            [self showHint:@"赞"];
            [_dataSource removeObjectAtIndex:row];
            data.ilike = [NSString stringWithFormat:@"%d",[data.ilike intValue]+1];
            [_dataSource insertObject:data atIndex:row];
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[LsDynamicDetailsViewController class]]) {
        LsDynamicDetailsViewController *dydetails = [segue destinationViewController];
        YdDynamic *yd = _dataSource[[(NSIndexPath*)sender row]];
        dydetails.cellIdentifier = [self cellIdentifierForModel:yd];
        dydetails.dynamicInfo = yd;
    }
}


@end
