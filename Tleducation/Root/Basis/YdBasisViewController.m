//
//  YdBasisViewController.m
//  judiciary
//
//  Created by lecochao on 2017/2/21.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdBasisViewController.h"

@interface YdBasisViewController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation YdBasisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        [self.view addSubview:_wkWebView];
        [self.view sendSubviewToBack:_wkWebView];
    }
    return _wkWebView;
}

- (void)webLoadRequestUrl:(NSString *)url
{
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webLoadName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:fileURL]];
}

- (BOOL)status:(id)json
{
    if (json) {
        if ([json[@"status"] intValue] ==1) {
            return YES;
        }else{
            [self showHint:json[@"msg"]];
            return NO;
        }
    }else{
        [self showHint:@"数据获取失败！"];
        return NO;
    }
}

- (BOOL)isLogin
{
    NSString *user = k_GET_OBJECT(Yd_user);
    if (user) {
        return YES;
    }
    
    WGAlertView *alter = [[WGAlertView alloc]initWithTitle:@"未登录" message:@"是否重新登录" block:^(NSInteger buttonIndex, WGAlertView *alert_) {
        if (buttonIndex ==0) {
            UIViewController *lodinVc = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationLoginVc"];
            [self presentViewController:lodinVc animated:YES completion:nil];
           [kNotificationCenter postNotificationName:Yd_Notification_logout object:nil];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
    [alter show];
    return NO;
}

- (void)tableRefresh:(UITableView *)_tableView
{
    _nowPage = 1;
    _nowPage = 1;
    [_tableView setTableFooterView:[UIView new]];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
        });
        if (++_nowPage >_totalPage) {
            _nowPage = _totalPage;
            [_tableView.mj_footer endRefreshing];
            [self showHint:@"没有更多了"];
        }else
            [self getDataSource];
    }];
    _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _nowPage = 1;
        [self getDataSource];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.mj_header endRefreshing];
        });
    }];
}

- (void)getDataSource{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKUIDelegate -
// 创建新的webview
// 可以指定配置对象、导航动作对象、window特性
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return webView;
}

// webview关闭时回调
- (void)webViewDidClose:(WKWebView *)webView
{
    
}

// 调用JS的alert()方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"____%@",message);
//    completionHandler();
}

// 调用JS的confirm()方法

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    NSLog(@"confirm____%@",message);
}

// 调用JS的prompt()方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"Finish");
    NSString *js = [NSString stringWithFormat:@"getNewsId(%@)",self._id];
    [webView evaluateJavaScript:js completionHandler:nil];
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"Fail");
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
