//
//  YdBasisViewController.h
//  judiciary
//
//  Created by lecochao on 2017/2/21.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface YdBasisViewController : UIViewController
// 刷新用页数
@property (assign,nonatomic) NSInteger nowPage;
@property (assign,nonatomic) NSInteger totalPage;

@property(nonatomic ,strong) WKWebView *wkWebView;
@property(nonatomic ,strong) NSString *_id;
//webview 加载
- (void)webLoadRequestUrl:(NSString *)url;
//加载本地web
- (void)webLoadName:(NSString *)fileName;

- (BOOL)status:(id)json;

- (BOOL)isLogin;

//刷新相关
- (void)tableRefresh:(UITableView *)_tableView;
//子类需重写加载数据
- (void)getDataSource;
@end
