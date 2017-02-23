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

@property(nonatomic ,strong) WKWebView *wkWebView;

//webview 加载
- (void)webLoadRequestUrl:(NSString *)url;

@end
