//
//  LsDynamicDetailsViewController.m
//  lushangjituan
//
//  Created by Chaos on 16/9/2.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "LsDynamicDetailsViewController.h"
#import "LsDynamicCommentsTableCell.h"
#import "LsDynamicTableViewCell.h"
#import "YdDynamicComment.h"
#import "STInputBar.h"
#import "ZLPhoto.h"
@interface LsDynamicDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (strong,nonatomic) STInputBar *inputBar;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (assign,nonatomic) NSInteger totalpage;
@property (assign,nonatomic) NSInteger nowpage;
@property (strong,nonatomic) NSString *cuid;//被评论或被回复者id
@property (strong,nonatomic) NSArray *thingList;

@end

@implementation LsDynamicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.inputBar];
    _nowpage = 1;
    [self getDataSource];
//    [self getDynamicThingList];
    if ([_dynamicInfo.uid isEqualToString:k_GET_OBJECT(Yd_user)]) {
        _delBtn.hidden = NO;//有删除全部的权限
    }else _delBtn.hidden = YES;//只有删除自己评论
    [self tableRefresh:_tableView];
    
}

-(STInputBar *)inputBar
{
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 60.f;
    _tableView.estimatedSectionHeaderHeight = 200.f;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_nowpage++ >_totalpage) {
            _nowpage = _totalpage;
        };
//        [self getDataSource];
    }];
    if (!_inputBar) {
        _inputBar = [STInputBar inputBar];
        _inputBar.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)-CGRectGetHeight(_inputBar.bounds)/2);
        [_inputBar setFitWhenKeyboardShowOrHide:YES];
        _inputBar.placeHolder = @"发布评论";
        
        kWeakSelf(self)
        [_inputBar setDidSendClicked:^(NSString *text) {
            [weakself.inputBar resignFirstResponder];
            weakself.inputBar.placeHolder = @"发布评论";
            if (text.length>0) {
                [weakself postCommentInfo:text];
            }
            
        }];
        [_inputBar setInputBarSizeChangedHandle:^{}];
    }
    return _inputBar;
}

#pragma mark - table -

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat sectionHeaderHeight = _sectionHeaderHeight+100;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        NSLog(@"1__%f",scrollView.contentOffset.y);
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        NSLog(@"2__%f",scrollView.contentOffset.y);
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//    
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_thingList.count>0) {
        return _dataSource.count +1;
    }else
        return _dataSource.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LsDynamicTableViewCell_Normal *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    [sectionHeaderView setValueData:_dynamicInfo];
    sectionHeaderView.block =^(LsDynamicClickStyle style , id model ,id sender){
        [self tableCellBlock:style Data:model ID:sender];
    };
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_thingList.count>0) {
        
        if (indexPath.row ==0) {
            LsDynamicThingListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LsDynamicThingListTableCell"];
            [cell setThingList:_thingList];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            LsDynamicCommentsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LsDynamicCommentsTableCell"];
            [cell setValueData:_dataSource[indexPath.row-1]];
            cell.block = ^(NSInteger item ,NSString *coid){[self dealWithComment:item Coid:coid IndexPath:indexPath];};
            cell.isSelfDy = !_delBtn.hidden;
            return cell;
        }
    }else{
        LsDynamicCommentsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LsDynamicCommentsTableCell"];
        [cell setValueData:_dataSource[indexPath.row]];
        cell.block = ^(NSInteger item ,NSString *coid){[self dealWithComment:item Coid:coid IndexPath:indexPath];};
        cell.isSelfDy = !_delBtn.hidden;
        return cell;
    }
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YdDynamicComment *model;
    if (_thingList.count>0) {
        if (indexPath.row>0) {
            model = _dataSource[indexPath.row -1];
            [_inputBar resignFirstResponder];
            _inputBar.placeHolder = [NSString stringWithFormat: @"回复 %@：",model.nickname];
            _cuid = model.uid;
            [_inputBar becomeFirstResponder];
        }
    }else{
        model = _dataSource[indexPath.row];
        [_inputBar resignFirstResponder];
        _inputBar.placeHolder = [NSString stringWithFormat: @"回复 %@：",model.nickname];
        _cuid = model.uid;
        [_inputBar becomeFirstResponder];
    }
}

- (void)tableCellBlock:(LsDynamicClickStyle)style Data:(YdDynamic *)model ID:(id)sender
{
    switch (style) {
//        case LsDynamicClickStyleUser:
//            [self performSegueWithIdentifier:@"pushUserInfoStoryboardSegue" sender:model];
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
        case LsDynamicClickStylePicture4:
            NSLog(@"cell__pic__4");
            [self lockChooseImg:4 dynamic:model.img ID:sender];
            break;
        case LsDynamicClickStylePicture5:
            NSLog(@"cell__pic__5");
            [self lockChooseImg:5 dynamic:model.img ID:sender];
            break;
        case LsDynamicClickStylePicture6:
            NSLog(@"cell__pic__6");
            [self lockChooseImg:6 dynamic:model.img ID:sender];
            break;
        case LsDynamicClickStyleLeftBtn:
            NSLog(@"cell__btn__left");
            [_inputBar resignFirstResponder];
            [self postDynamicThingData:model];
            break;
        case LsDynamicClickStyleRightBtn:
            NSLog(@"cell__btn__Right");
            _inputBar.placeHolder = @"发布评论";
            [_inputBar becomeFirstResponder];
            _cuid = nil;
            break;
        default:
            break;
    }
    
}

- (void)dealWithComment:(NSInteger)item Coid:(NSString *)coid IndexPath:(NSIndexPath *)indexPath
{
    switch (item) {
        case 0:
            NSLog(@"copy %@",indexPath);
            break;
        case 1:
            NSLog(@"删除");
            if (_thingList.count>0) {
               [_dataSource removeObjectAtIndex:indexPath.row-1];
            }else [_dataSource removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView reloadData];
            [self dealWithCommentCoid:coid];
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
    // 能够删除
    //    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = nn-1;
    // 展示控制器
    [pickerBrowser showPickerVc:self];

}

- (void)postCommentInfo:(NSString *)txt
{
    if (![self isLogin]) {
        return;
    }
    NSString *uid = k_GET_OBJECT(Yd_user);
    NSDictionary *dic = @{@"tid":_dynamicInfo.trendid,@"uid":uid,@"title":txt};
    if (_cuid) {
        dic = @{@"tid":_dynamicInfo.trendid,@"uid":uid,@"title":txt,@"cuid":_cuid};
    }
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_trendPostComment Params:dic success:^(id json) {
        if ([self status:json]) {
            [self showHint:@"评论成功"];
            [self getDataSource];
        }
        
    } fail:^(NSError *error) {
        [self showHint:@"评论失败"];
    }];
}

#pragma mark - data -
-(void)getDataSource
{
    if (![self isLogin]) {
        return;
    }
    [self showHUDWithHint:nil];
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_trendCommentList Params:@{@"tid":_dynamicInfo.trendid} success:^(id json) {
        if ([self status:json]) {
            _dataSource = [NSMutableArray array];
            NSArray *array = json[@"data"];
            for (NSDictionary *dic in array) {
                NSError *error;
                YdDynamicComment *model = [[YdDynamicComment alloc]initWithDictionary:dic error:&error];
                if (!error) {
                    [_dataSource addObject:model];
                }
            }
            [_tableView reloadData];
        }
     [self hideHud];
     } fail:^(NSError *error) {
         [self hideHud];
     }];
    
}


-(void)dealWithCommentCoid:(NSString *)coid
{
    if (![self isLogin]) {
        return;
    }
    NSString *uid = k_GET_OBJECT(Yd_user);
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_del_comment Params:@{@"uid":uid,@"cid":coid} success:^(id json) {
        if ([self status:json]) {
            [self showHint:@"已删除"];
        }else {
            [self getDataSource];
        }
    } fail:^(NSError *error) {
        NSLog(@"删除失败");
        [self getDataSource];
    }];
}
/*
-(void)getDynamicThingList
{
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        [XCNetworking XC_GET_JSONDataWithUrl:Ls_GetDynamicThingList Params:@{@"token":token,@"mdid":_dynamicInfo.md_id} success:^(id json) {
            if ([self status:json[JOSNstatus]]) {
                _thingList = [NSArray arrayWithArray:json[JOSNinfo]];
                [_tableView reloadData];
            }
        } fail:^(NSError *error) {
            LogLoc(@"%@",error.localizedDescription);
        }];
    }else [self dealWithToken];
    
}

*/
- (void)postDynamicThingData:(YdDynamic *)data
{
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_del_add_ilike Params:@{@"tid":data.trendid}  success:^(id json) {
        if ([self status:json]) {
            [self showHint:@"赞"];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)delDyAction:(id)sender {
    
    if (![self isLogin]) {
        return;
    }
    NSString *uid = k_GET_OBJECT(Yd_user);
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_dy_del_trend Params:@{@"uid":uid,@"tid":_dynamicInfo.trendid} success:^(id json) {
        if ([self status:json]) {
            [self showHint:@"删除成功"];
            [self delWithFile];
            [self backAction:nil];
        }else {
            [self showHint:@"删除失败"];
        }
    } fail:^(NSError *error) {
        [self showHint:@"删除失败"];
    }];
}

-(void)delWithFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths lastObject] stringByAppendingString:_dynamicInfo.video];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        return;
    }
    NSError *error;
    [fileManager removeItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"本地文件删除失败");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
}


@end
