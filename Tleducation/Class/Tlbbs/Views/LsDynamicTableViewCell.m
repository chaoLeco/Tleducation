//
//  LsDynamicTableViewCell.m
//  lushangjituan
//
//  Created by Chaos on 16/8/26.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "LsDynamicTableViewCell.h"
#import "NSString+Emoji.h"
#import "NSDate+Category.h"
#pragma mark - 仅文字  -
@implementation LsDynamicTableViewCell_Normal

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftBtn.particleImage = [UIImage imageNamed:@"Sparkle"];
    _leftBtn.particleScale = 0.05;
    _leftBtn.particleScaleRange = 0.02;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setValueData:(YdDynamic *)model
{
    _data = model;
    _lblName.text = model.nickname;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%d.png",arc4random()%3 +1]];
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Yd_Url_base,model.headimg]]
                  placeholderImage:image];
    _lblTime.text = [NSDate formattedTimeFromTimeInterval:[model.time longLongValue]];
    _lblContent.text = [model.title stringByReplacingEmojiCheatCodesWithUnicode];
    _lblTing.text = [NSString stringWithFormat:@"(%@)",model.ilike];
    _leftBtn.selected = NO;
    _lblTing.textColor = [UIColor darkGrayColor];
//    if ([model.mb_thingstatus isEqualToString:@"1"]) {
//        _leftBtn.selected = YES;
//    }else {
//        _leftBtn.selected = NO;
//    }
}


- (IBAction)btnLeftAction:(id)sender {

    if (!_leftBtn.selected) {
        [_leftBtn popOutsideWithDuration:0.5];
        [_leftBtn animate];
        _lblTing.textColor = kRGBColor(19, 150, 219);
        _lblTing.text = [NSString stringWithFormat:@"(%d)",[_data.ilike intValue]+1];
        if (_block) {
            _block(LsDynamicClickStyleLeftBtn,_data,_leftBtn);
        }
        _leftBtn.selected = YES;
    }else {
//        _lblTing.textColor = [UIColor darkGrayColor];
    }

}
- (IBAction)btnRightAction:(id)sender {
    //评价
    if (_block) {
        _block(LsDynamicClickStyleRightBtn,_data,nil);
    }
}

@end

#pragma mark - 单张图片  -

@implementation LsDynamicTableViewCell_Picture

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgAction)];
    [self.imgOnly addGestureRecognizer:singleTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setValueData:(YdDynamic *)model
{
    [super setValueData:model];
    NSString *str = [NSString stringWithFormat:@"%@%@",Yd_Url_base,model.img];
    [_imgOnly sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
}

-(void)clickImgAction
{
    if (self.block) {
        self.block(LsDynamicClickStylePicture1,self.data,self);
    }
}
@end

#pragma mark - 多张图片  -

@implementation LsDynamicTableViewCell_Pictures

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg1Action)];
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg2Action)];
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg3Action)];
    [self.img1 addGestureRecognizer:singleTap1];
    [self.img2 addGestureRecognizer:singleTap2];
    [self.img3 addGestureRecognizer:singleTap3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setValueData:(YdDynamic *)model
{
    _img2.hidden = NO;
    _img3.hidden = NO;
    [super setValueData:model];
    NSArray *array = [model.img componentsSeparatedByString:@","];
    switch (array.count) {
        case 0:
            NSLog(@"0动态id%@ img_%@",model.trendid,model.img);
            break;
        case 1:
            NSLog(@"1动态id%@ img_%@",model.trendid,model.img);
            break;
        case 2:{
            NSString *str1 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[0]];
            [_img1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str2 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[1]];
            [_img2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            _img3.hidden = YES;
        }
            break;
        default:
            if (array.count>=3) {
                NSString *str1 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[0]];
                [_img1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
                NSString *str2 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[1]];
                [_img2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
                NSString *str3 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[2]];
                [_img3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            }
            break;
    }
    
}

- (void)clickImg1Action
{
    if (self.block) {
        self.block(LsDynamicClickStylePicture1,self.data,self);
    }
}
- (void)clickImg2Action
{
    if (self.block) {
        self.block(LsDynamicClickStylePicture2,self.data,self);
    }
}
- (void)clickImg3Action
{
    if (self.block) {
        self.block(LsDynamicClickStylePicture3,self.data,self);
    }
}

@end

#pragma mark - 多张图片 Dynamic详情 -

@implementation LsDynamicTableViewCell_Pictures_6

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg4Action)];
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg5Action)];
    UITapGestureRecognizer *singleTap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg6Action)];
    [self.img4 addGestureRecognizer:singleTap4];
    [self.img5 addGestureRecognizer:singleTap5];
    [self.img6 addGestureRecognizer:singleTap6];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setValueData:(YdDynamic*)model
{
    [super setValueData:model];
    NSArray *array = [model.img componentsSeparatedByString:@","];
    self.img3.hidden = NO;
    self.img6.hidden = NO;
    switch (array.count) {
        case 4:{
            NSString *str1 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str2 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str4 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[2]];
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:str4] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str5 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[3]];
            [self.img5 sd_setImageWithURL:[NSURL URLWithString:str5] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            self.img3.hidden = YES;
            self.img6.hidden = YES;
        }
            break;
        case 5:{
            NSString *str1 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str2 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str3 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[2]];
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str4 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[3]];
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:str4] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str5 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[4]];
            [self.img5 sd_setImageWithURL:[NSURL URLWithString:str5] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            self.img6.hidden = YES;
        }
            break;
        case 6:{
            NSString *str1 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str2 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str3 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[2]];
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str4 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[3]];
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:str4] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str5 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[4]];
            [self.img5 sd_setImageWithURL:[NSURL URLWithString:str5] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            NSString *str6 = [NSString stringWithFormat:@"%@%@",Yd_Url_base,array[5]];
            [self.img6 sd_setImageWithURL:[NSURL URLWithString:str6] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
        }
            break;
        default:
            break;
    }
}

- (void)clickImg4Action
{
    if (self.block) {
        self.block(LsDynamicClickStylePicture4,self.data,self);
    }
}
- (void)clickImg5Action
{
    if (self.block) {
        self.block(LsDynamicClickStylePicture5,self.data,self);
    }
}
- (void)clickImg6Action
{
    if (self.block) {
        self.block(LsDynamicClickStylePicture6,self.data,self);
    }
}

@end


#pragma mark - 视频  -
#import "TrVidoePlayView.h"
#import "KZVideoConfig.h"
#import "UIView+HUD.h"
@implementation LsDynamicTableViewCell_Video

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setValueData:(YdDynamic *)model
{
    [super setValueData:model];
    _videoUrl = model.video;
    _thumbUrl = [NSString stringWithFormat:@"%@%@",Yd_Url_base,model.thumb];
    [_imgthum sd_setImageWithURL:[NSURL URLWithString:_thumbUrl] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
}

- (IBAction)playAction:(UIButton *)sender {
   //  _videoUrl =  /trend_media/20170426151027_73481.mov
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *voideCachesPath = [[paths lastObject] stringByAppendingString:@"/trend_media/"];
    NSString *videoPath = [[paths lastObject] stringByAppendingString:_videoUrl];

    if (![self fileExistsAtPath:videoPath]) {
        [_imgthum showHUDDeterminat];
        sender.hidden = YES;
        [XCNetworking XC_Down_UploadWithUrl:[NSString stringWithFormat:@"%@%@",Yd_Url_base,_videoUrl]
                                   FileName:[_videoUrl substringFromIndex:1]
                                   Progress:^(CGFloat Progress) {
                                       [_imgthum HUDProgress:Progress];
                                   }
                                    success:^(id filePath) {
                                        [_imgthum hideHud];
                                        if ([self fileExistsAtPath:[filePath relativePath]]) {
                                            [TrVidoePlayView playVideo:filePath Thum:_thumbUrl From:_imgthum];
                                        }
                                        sender.hidden = NO;
                                    }
                                       fail:^(NSError *error) {
                                           [_imgthum hideHud];
                                           NSLog(@"%@ 下载失败",_videoUrl);
                                           sender.hidden = NO;
                                       }];
    }else {
        [TrVidoePlayView playVideo:[NSURL fileURLWithPath:videoPath] Thum:_thumbUrl From:_imgthum];
    }
}

- (BOOL)fileExistsAtPath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *voideCachesPath = [[paths lastObject] stringByAppendingString:@"/trend_media"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:voideCachesPath];
    if (!success) {
         [fileManager createDirectoryAtPath:voideCachesPath withIntermediateDirectories:YES attributes:nil error:nil];
        return NO;
    }else {
        return [fileManager fileExistsAtPath:path];
    }
}

@end
