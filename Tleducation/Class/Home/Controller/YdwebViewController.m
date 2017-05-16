//
//  YdwebViewController.m
//  judiciary
//
//  Created by lecochao on 2017/2/22.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdwebViewController.h"

@interface YdwebViewController ()

@end

@implementation YdwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_xinInfo) {
        self.title = _xinInfo.st;
        [self webLoadRequestUrl:[NSString stringWithFormat:@"%@%@",Yd_Url_base,_xinInfo.dc]];
    }
    if (_banner) {
        self.title = _banner.title;
        [self webLoadRequestUrl:[NSString stringWithFormat:@"%@%@",Yd_Url_base,_banner.url]];
    }
    if (_url) {
        [self webLoadRequestUrl:_url];
    }
}

- (IBAction)goback:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
