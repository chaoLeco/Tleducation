//
//  LsFriendsDynamicViewController.m
//  lushangjituan
//
//  Created by Chaos on 16/8/26.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "LsFriendsDynamicViewController.h"
#import "LsDynamicDetailsViewController.h"
#import "PKFullScreenPlayerViewController.h"
#import "LsUserInfoViewController.h"
#import "LsDynamicTableViewCell.h"
#import "UIImage+PKShortVideoPlayer.h"
#import "STInputBar.h"
#import "NSString+Emoji.h"
#import "ZLPhoto.h"

NSString *const dynamicCellID_normal = @"LsDynamicTableViewCell_Normal";
NSString *const dynamicCellID_Picture = @"LsDynamicTableViewCell_Picture";
NSString *const dynamicCellID_Pictures = @"LsDynamicTableViewCell_Pictures";
NSString *const dynamicCellID_Pictures_6 = @"LsDynamicTableViewCell_Pictures_6";
NSString *const dynamicCellID_Video = @"LsDynamicTableViewCell_Video";
@interface LsFriendsDynamicViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgRank;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (strong,nonatomic) STInputBar *inputBar;
@property (strong,nonatomic) NSMutableArray *dataSource;

@property (assign,nonatomic) NSInteger nowPage;
@property (assign,nonatomic) NSInteger totalpage;

@property (strong,nonatomic) NSString *dynamicmdid;/**< 将要被评论动态id*/
@end

@implementation LsFriendsDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.estimatedRowHeight = 200.f;
    _tableview.tableFooterView = [UIView new];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_tableview.tableHeaderView.bounds), CGRectGetWidth(_tableview.bounds), CGRectGetHeight(_tableview.bounds))];
    view.backgroundColor = [UIColor whiteColor];
    [_tableview addSubview:view];
    [_tableview sendSubviewToBack:view];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_nowPage++ >_totalpage) {
            _nowPage = _totalpage;
        };
        [self getDynamicDataSource];
    }];
    [self.view addSubview:self.inputBar];
    [self getDynamicDatas];
    [self getDynamicDataSource];

}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDynamicDatas];
    if (_myInfo) {
        _name.text = _myInfo.realname;
//        NSString *str = [NSString stringWithFormat:@"%@%@",Ls_url_avatar,_myInfo.avatar];
//        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"QQ.jpg"]];
        [self getFriendInfo:_myInfo.phone];
    }
}


-(STInputBar *)inputBar
{
    if (!_inputBar) {
        _inputBar = [STInputBar inputBar];
        _inputBar.hidden = YES;
        _inputBar.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)-CGRectGetHeight(_inputBar.bounds)/2);
        [_inputBar setFitWhenKeyboardShowOrHide:YES];
        _inputBar.placeHolder = @"发布评论";
        
        WEAKSELF
        [_inputBar setDidSendClicked:^(NSString *text) {
            weakSelf.inputBar.placeHolder = @"发布评论";
            weakSelf.inputBar.hidden = YES;
            NSLog(@"发送_%f_%@",CGRectGetHeight(weakSelf.inputBar.bounds),text);
            [weakSelf postCommentInfo:text];
            [weakSelf.inputBar resignFirstResponder];
        }];
        [_inputBar setInputBarSizeChangedHandle:^{}];
    }
    return _inputBar;
}

- (void)getFriendInfo:(NSString *)phone
{
    [LsMemberTabData getInfoWithPhone:phone Info:^(LsMemberInfo *info) {
        if (info) {
            NSString *str = [NSString stringWithFormat:@"%@%@",Ls_url_avatar,info.avatar];
            [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:Ls_preset]];
        }else [MessageTools getFriendInfoandBlock:^(BOOL isSuc) {
            if (!isSuc) {
                [self showHint:@"请检查网络"];
            }
        }];
    }];
}

- (void)getUserInfo
{
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        [XCNetworking XC_GET_JSONDataWithUrl:Ls_getMemberBasicInfo Params:@{@"token":token} success:^(id json) {
            if ([self status:json[JOSNstatus]]) {
                NSError *error;
                _myInfo = [[LsPersonModel alloc]initWithDictionary:json[JOSNinfo] error:&error];
                LSHL_SET_OBJECT(_myInfo.uid, @"uid");
                if (!error) {
                    _name.text = _myInfo.realname;
                    NSString *str = [NSString stringWithFormat:@"%@%@",Ls_url_avatar,_myInfo.avatar];
                    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"QQ.jpg"]];
                }
            }
        } fail:^(NSError *error) {
            
        }];
    }
}

#pragma mark - table -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;//cell数量
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LsDynamicModel *dy = _dataSource[indexPath.row];
   
    NSString *identifier = [self cellIdentifierForModel:dy];
    identifier = [identifier isEqualToString:dynamicCellID_Pictures_6]?dynamicCellID_Pictures:identifier;
    LsDynamicTableViewCell_Normal *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setValueData:dy];
    cell.block =^(LsDynamicClickStyle style , LsDynamicModel *model ,id sender){
        [self tableCellBlock:style Data:model ID:sender];
    };
    return cell;
}

- (NSString *)cellIdentifierForModel:(LsDynamicModel *)dy
{
    if ([dy.mb_format isEqualToString:@"1"]) {
        return dynamicCellID_normal;
    }
    if ([dy.mb_format isEqualToString:@"2"]) {
        NSArray *array = [dy.mb_dynamic_img componentsSeparatedByString:@","];
        if (array.count==1) {
            return dynamicCellID_Picture;
        }else if (array.count==6) {
            return dynamicCellID_Pictures_6;
        }else if (array.count<=3) {
            return dynamicCellID_Pictures;
        }else
            return dynamicCellID_Pictures_6;
    }
    if ([dy.mb_format isEqualToString:@"3"]) {
        return dynamicCellID_Video;
    }
    return nil;
}

//cell 将要出现的时候 video playing
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell isKindOfClass:[LsDynamicTableViewCell_Video class]]) {
//        [[(LsDynamicTableViewCell_Video*)cell playView] play];
//    }
//}

//cell 将要出现的时候 video stop
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell isKindOfClass:[LsDynamicTableViewCell_Video class]]) {
        [[(LsDynamicTableViewCell_Video*)cell playView] pause];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat scale = 1.0;
    // 放大
    if (offsetY < 0) {
        // 允许下拉放大的最大距离为300
        // 1.5是放大的最大倍数，当达到最大时，大小为：1.5 * 70 = 105
        // 这个值可以自由调整
        scale = MIN(2.0, 1 - offsetY / 500);
        self.navigationController.navigationBar.alpha = 0;
        if (offsetY<-60 && _activity.isHidden) {
            _nowPage = 1;
            [self getDynamicDataSource];
        }
    } else if (offsetY > 0) { // 缩小
        // 允许向上超过导航条缩小的最大距离为300
        // 为了防止缩小过度，给一个最小值为0.45，其中0.45 = 31.5 / 70.0，表示
        // 头像最小是31.5像素
        // scale = MAX(0.45, 1 - offsetY / 500);
        self.navigationController.navigationBar.alpha = offsetY/200.f;
        if (offsetY>125) {
            self.navigationController.navigationBar.alpha = 1;
        }
    }

    self.imgBg.transform = CGAffineTransformMakeScale(scale, scale);
    if (!_inputBar.hidden) {
        _inputBar.hidden = YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_inputBar resignFirstResponder];
    [self performSegueWithIdentifier:@"pushDynamicDetailsStoryboardSegue" sender:indexPath];
}

- (void)tableCellBlock:(LsDynamicClickStyle)style Data:(LsDynamicModel *)model ID:(id)sender
{
    switch (style) {
        case LsDynamicClickStyleUser:
            [self performSegueWithIdentifier:@"pushUserInfoStoryboardSegue" sender:model];
            break;
        case LsDynamicClickStylePicture1:
            NSLog(@"cell__pic__1");
            [self lockChooseImg:1 dynamic:model.mb_dynamic_img ID:sender];
            break;
        case LsDynamicClickStylePicture2:
            NSLog(@"cell__pic__2");
            [self lockChooseImg:2 dynamic:model.mb_dynamic_img ID:sender];
            break;
        case LsDynamicClickStylePicture3:
            NSLog(@"cell__pic__3");
            [self lockChooseImg:3 dynamic:model.mb_dynamic_img ID:sender];
            break;
        case LsDynamicClickStyleVideo:
            NSLog(@"cell__Video__");
            [self playVoideWith:model.mb_dynamic_voide];
            break;
        case LsDynamicClickStyleLeftBtn:
            NSLog(@"cell__btn__left");
            [_inputBar resignFirstResponder];
            [self postDynamicThing:sender Data:model];
            break;
        case LsDynamicClickStyleRightBtn:
            NSLog(@"cell__btn__Right");
            _inputBar.hidden = NO;
            _dynamicmdid = model.md_id;
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
            LogLoc(@"错误 没有图片");
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
                NSString *imgUrl = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,imgStr];
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

- (void)playVoideWith:(NSString *)voidePath

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *voideCachesPath = [[paths lastObject] stringByAppendingString:@"/voideCaches/"];
    NSString *filePath = [voideCachesPath stringByAppendingString:voidePath];
    if (![self fileExistsAtPath:filePath]) {
        [self showHUDDeterminat];
        [XCNetworking XC_Down_UploadWithUrl:[NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicvoide,voidePath]
                                   FileName:voidePath
                                   Progress:^(CGFloat Progress) {
                                       [self HUDProgress:Progress];
                                   }
                                    success:^(id filePath) {
                                        [self hideHud];
                                        PKFullScreenPlayerViewController *viewController = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:filePath previewImage:[UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:filePath]]];
                                        [self presentViewController:viewController animated:NO completion:NULL];
                                    }
                                       fail:^(NSError *error) {
                                           [self hideHud];
                                           LogLoc(@"%@ 下载失败",voidePath);
                                       }];
    }else {
        PKFullScreenPlayerViewController *viewController = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:filePath previewImage:[UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:filePath]]];
        [self presentViewController:viewController animated:NO completion:NULL];
    }
}

- (BOOL)fileExistsAtPath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *voideCachesPath = [[paths lastObject] stringByAppendingString:@"/voideCaches"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:voideCachesPath];
    if (!success) {
        [fileManager createDirectoryAtPath:voideCachesPath withIntermediateDirectories:YES attributes:nil error:nil];
        return NO;
    }else {
        return [fileManager fileExistsAtPath:path];
    }
}
#pragma mark - action -

- (IBAction)publishDynamicAction:(id)sender {
    [self performSegueWithIdentifier:@"pushPublishDynamicStoryboardSegue" sender:nil];
}

- (IBAction)backSegueToLsFriendsDynamicViewController:(UIStoryboardSegue *)segue {
    UIViewController *sourceViewController = segue.sourceViewController;
    
    NSLog(@"from %@ vc",[sourceViewController class]);
    self.navigationController.navigationBar.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data -

- (void)getDynamicDatas
{
    [LsDynamicFMDB getAllWithOrder:@"desc" Info:^(NSArray<LsDynamicModel *> *data) {
        if (data) {
            _dataSource = [NSMutableArray arrayWithArray:data];
            [_tableview reloadData];
            _nowPage = 1;
        }
    }];
    
}

- (void)getDynamicDataSource
{
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        _activity.hidden = NO;
        [_activity startAnimating];
        NSDictionary *dic = @{@"token":token,@"p":[NSString stringWithFormat:@"%lu",_nowPage]};
        [XCNetworking XC_GET_JSONDataWithUrl:Ls_GetDynamicList Params:dic success:^(id json) {
            _activity.hidden = YES;
            [_activity startAnimating];
            [_tableview.mj_footer endRefreshing];
            if ([self status:json[JOSNstatus]]) {
                if (![json[JOSNinfo][@"pages"] isKindOfClass:[NSNull class]]) {
                    _totalpage = [json[JOSNinfo][@"pages"] integerValue];
                }
                
                NSArray *array = [NSArray arrayWithArray:json[JOSNinfo][@"list"]];
                if (_nowPage ==1) {
                    _dataSource = [NSMutableArray array];
                    if (array.count==0) {
                        [LsDynamicFMDB delRecord];
                    }
                }
                for (NSDictionary *dic in array) {
                    NSError *error;
                    LsDynamicModel *model = [[LsDynamicModel alloc]initWithDictionary:dic error:&error];
                    if (!error) {
                        [LsDynamicFMDB saveDBWithData:nil Data:model];
                        [_dataSource addObject:model];
                    }
                }
                
                [_tableview reloadData];
                
            }
        } fail:^(NSError *error) {
            _activity.hidden = YES;
            [_activity startAnimating];
            [_tableview.mj_footer endRefreshing];
        }];
    }else [self dealWithToken];
 
}

-(void)postCommentInfo:(NSString *)comment_info
{
    NSString *info = [comment_info stringByReplacingEmojiUnicodeWithCheatCodes];
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:token forKey:@"token"];
        [dic setObject:_dynamicmdid forKey:@"mdid"];
        [dic setObject:info forKey:@"comment_info"];

        [XCNetworking XC_Post_JSONWithUrl:Ls_PutComments parameters:dic success:^(id json) {
            if ([self status:json[JOSNstatus]]) {
                [self showHint:@"评论成功"];
            }
        } fail:^(NSError *error) {
            [self showHint:@"评论成功,请检查查网络"];
        }];
    }
    
}

- (void)postDynamicThing:(UIButton *)sender Data:(LsDynamicModel *)model
{
    NSString *status;
    if (sender.selected) {
        status = @"2";//取消
    }else status = @"1";//点赞
    NSString *token = LSHL_GET_TOKEN
    if (token) {
        [XCNetworking XC_Post_JSONWithUrl:Ls_UpdateMemberDynamicThing parameters:@{@"token":token,@"mdid":model.md_id,@"status":status} success:^(id json) {
            if ([self status:json[JOSNstatus]]) {
                sender.selected = !sender.selected;
                [self showHint:json[JOSNinfo]];
                
                //更新DB数据
                model.mb_thingstatus = status;
                [LsDynamicFMDB updateInfoWithModel:model];
            }
        } fail:^(NSError *error) {
            [self showHint:@"操作失败"];
        }];
    }else [self dealWithToken];
}

#pragma mark - Segue -

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.navigationController.navigationBar.alpha = 1;
    UIViewController *vc = [segue destinationViewController];
    
//    UITableViewCell *cell = [_tableview cellForRowAtIndexPath:sender];
    if ([vc isKindOfClass:[LsDynamicDetailsViewController class]]) {
        LsDynamicDetailsViewController *detailsVC = (LsDynamicDetailsViewController*)vc;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        LsDynamicModel *info = _dataSource[indexPath.row];
        detailsVC.cellIdentifier = [self cellIdentifierForModel:info];
        detailsVC.dynamicInfo = info;
    }
    
    if ([vc isKindOfClass:[LsUserInfoViewController class]]) {
        LsUserInfoViewController *userInfoVC = (LsUserInfoViewController*)vc;
        if ([sender isKindOfClass:[LsDynamicModel class]]) {
            LsDynamicModel *model = (LsDynamicModel *)sender;
            userInfoVC.userPhone = model.phone;
            userInfoVC.isUser = NO;
        }else {
            userInfoVC.info_detail = _myInfo;
            userInfoVC.userPhone = LSHL_GET_OBJECT(USERID);
            userInfoVC.isUser = YES;
        }
 
    }
}


@end
