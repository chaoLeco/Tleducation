//
//  YdUserInfoViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/11.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdUserInfoViewController.h"
#import "YdUserInfoTableCell.h"
@interface YdUserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *titles;
@property (strong,nonatomic) UIImage *portraitImg;
@end

@implementation YdUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSource];
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"头像",@"昵称",@"手机号",@"密码"];
    }
    return _titles;
}

- (void)getDataSource
{
    NSString *userid = k_GET_OBJECT(Yd_user);
    [XCNetworking XC_GET_JSONDataWithUrl:Yd_Url_User_info Params:@{@"userid":userid} success:^(id json) {
        if ([self status:json]) {
            NSError *error;
            _info = [[YdUser alloc] initWithDictionary:json[@"data"] error:&error];
            if (!error) {
                [_tableView reloadData];
            }
        }else
            [self showHint:@"好想出错了😳"];
    } fail:^(NSError *error) {
        [self showHint:@"网络错误"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 70;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YdUserInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YdUserInfoTableCell"];
    cell.lbltitle.text = self.titles[indexPath.row];
    if (indexPath.row>0) {
        cell.lblSubtitle.hidden = NO;
        cell.subImage.hidden = YES;
    }else{
        cell.lblSubtitle.hidden = YES;
        cell.subImage.hidden = NO;
    }
    switch (indexPath.row) {
        case 0:
            if (_portraitImg) {
                cell.subImage.image = _portraitImg;
            }else
            [cell.subImage sd_setImageWithURL:[NSURL URLWithString:_info.headimg] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]]];
            break;
        case 1:
            cell.lblSubtitle.text = _info.username?_info.username:_info.nickname;
            break;
        case 2:
            cell.lblSubtitle.text = _info.usertel;
            break;
        case 3:
            cell.lblSubtitle.text = @"可设置或修改密码";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self editorHeadportrait];
            break;
        case 1:
            [self editorNickname];
            break;
        case 2:
            [self showHint:@"暂时不支持修改手机号"];
            break;
        case 3:
            [self performSegueWithIdentifier:@"pushYdSetPasswordViewController" sender:nil];
            break;
        default:
            break;
    }
    //    [self performSegueWithIdentifier:@"pushYdListDetalisViewControllerSegue" sender:self.navigationItem.title];
}

- (IBAction)logoutAction:(id)sender {
    WGAlertView *alert = [[WGAlertView alloc]initWithTitle:nil message:@"是否退出登录" block:^(NSInteger buttonIndex, WGAlertView *alert_) {
        if (buttonIndex==0) {
            k_REMOVE_OBJECT(Yd_user);
            [kNotificationCenter postNotificationName:Yd_Notification_logout object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert show];
}

- (void)editorNickname{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"修改昵称"                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = _info.username?_info.username:_info.nickname;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self postUserNickname:alertController.textFields[0].text];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)editorHeadportrait {
    //头像修改
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //添加Button
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self submitImg:info];
    }];
    
}

- (void)submitImg:(NSDictionary *)info
{
    _portraitImg = [info objectForKey:UIImagePickerControllerEditedImage];
    [_tableView reloadData];
    NSString *userid= k_GET_OBJECT(Yd_user);
    if (userid) {
        [self showHUDWithHint:nil];
        NSData *data = UIImageJPEGRepresentation(_portraitImg, 0.8);
        [XCNetworking XC_Post_UploadWithUrl:@"" Params:@{@"userid":userid} Data_arr:@[@{@"picKey":@"headerphoto",@"picData":data}] success:^(id responseObject) {
            if ([self status:responseObject]) {
                [self showHint:@"新头像已保存"];
                [kNotificationCenter postNotificationName:Yd_Notification_login object:nil];
            }
            [self hideHud];
        } fail:^(NSError *error) {
            [self hideHud];
            [self showHint:@"网络错误，提交失败"];
//            NSString *headStr = [NSString stringWithFormat:@"%@sifanvshen/%@",Yd_url_basis,_userInfo.user_headsmallimage];
            _portraitImg = nil;
            [_tableView reloadData];
        }];
    }
}

- (void)postUserNickname:(NSString *)name
{
    NSString *userid= k_GET_OBJECT(Yd_user);
    if (userid) {
        [self showHUDWithHint:nil];
        [XCNetworking XC_Post_UploadWithUrl:@"" Params:@{@"userid":userid,@"":name} Data_arr:nil success:^(id responseObject) {
            if ([self status:responseObject]) {
                [self showHint:@"新头像已保存"];
                [kNotificationCenter postNotificationName:Yd_Notification_login object:nil];
            }
            [self hideHud];
        } fail:^(NSError *error) {
            [self hideHud];
            [self showHint:@"网络错误，提交失败"];
            //            NSString *headStr = [NSString stringWithFormat:@"%@sifanvshen/%@",Yd_url_basis,_userInfo.user_headsmallimage];
            _portraitImg = nil;
            [_tableView reloadData];
        }];
    }
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
