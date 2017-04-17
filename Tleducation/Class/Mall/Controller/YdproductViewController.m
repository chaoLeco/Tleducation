//
//  YdproductViewController.m
//  Tleducation
//
//  Created by lecochao on 2017/4/12.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "YdproductViewController.h"
#import "SDCycleScrollView.h"
#import "SDPhotoBrowser.h"
@interface YdproductViewController ()<SDCycleScrollViewDelegate,SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webHeight;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UILabel *lblsubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblsubtitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblpice;//￥
@property (weak, nonatomic) IBOutlet UILabel *lblpice_mm;
@end

@implementation YdproductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInfo
{
    self.cycleScrollView.localizationImageNamesGroup = @[@"ad_1.jpg",@"ad_2.jpg",@"ad_3.jpg",@"ad_4.jpg"];
    if (_product) {
        _lblpice.text = [NSString stringWithFormat:@"￥%@",_product.price];
        _lblpice_mm.text = [NSString stringWithFormat:@"￥%@",_product.member_price];
        _lbltitle.text = _product.productname;
        _lblsubtitle.text = [NSString stringWithFormat:@"地址:%@",_product.storeaddr];
        _lblsubtitle2.text = [NSString stringWithFormat:@"联系电话:%@",_product.storetel];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    _webHeight.constant = height;
    //document.body.scrollHeight
}


#pragma mark - sd -

-(SDCycleScrollView *)cycleScrollView
{
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"zwt_lie"];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.infiniteLoop = NO;
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.delegate = self;
    return _cycleScrollView;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = cycleScrollView;
    
    browser.imageCount = cycleScrollView.localizationImageNamesGroup.count;
    
    browser.currentImageIndex = index;
    
    browser.delegate = self;
    
    [browser show]; // 展示图片浏览器
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
}


- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSString *imgName = _cycleScrollView.localizationImageNamesGroup[index];
    return [UIImage imageNamed:imgName];
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSString *imgName = _cycleScrollView.localizationImageNamesGroup[index];
    NSURL *imgPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:imgName ofType:nil]];
    return imgPath;
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
