//
//  LsDynamicTableViewCell.m
//  lushangjituan
//
//  Created by Chaos on 16/8/26.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import "LsDynamicTableViewCell.h"
#import "NSString+Emoji.h"
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

//- (void)setValueData:(LsDynamicModel *)model
//{
//    _data = model;
//    _lblName.text = model.realname;
//    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Ls_url_avatar,model.avatar]]
//                  placeholderImage:[UIImage imageNamed:Ls_preset]];
//    _lblTime.text = [NSDate formattedTimeFromTimeInterval:[model.mb_addtime longLongValue]];
//    _lblContent.text = [model.mb_dynamic_info stringByReplacingEmojiCheatCodesWithUnicode];
//    if (model.mb_jingwei.length<10) {
//        _locationBtn.hidden = YES;
//    }else {
//        [_locationBtn setTitle:model.mb_cityname forState:UIControlStateNormal];
//        _locationBtn.hidden = NO;
//    }
//    if ([model.mb_thingstatus isEqualToString:@"1"]) {
//        _leftBtn.selected = YES;
//    }else {
//        _leftBtn.selected = NO;
//    }
//}


- (IBAction)btnLeftAction:(id)sender {

    if (!_leftBtn.selected) {
        [_leftBtn popOutsideWithDuration:0.5];
        [_leftBtn animate];
    }else {
    }
    
    if (_block) {
        _block(LsDynamicClickStyleLeftBtn,_data,_leftBtn);
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

- (void)setValueData:(id)model
{
    [super setValueData:model];
//    NSString *str = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,model.mb_dynamic_img];
    [_imgOnly sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
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

- (void)setValueData:(id)model
{
    _img2.hidden = NO;
    _img3.hidden = NO;
    [super setValueData:model];
//    NSArray *array = [model.mb_dynamic_img componentsSeparatedByString:@","];
//    switch (array.count) {
//        case 0:
//            NSLog(@"0动态id%@ img_%@",model.md_id,model.mb_dynamic_img);
//            break;
//        case 1:
//            NSLog(@"1动态id%@ img_%@",model.md_id,model.mb_dynamic_img);
//            break;
//        case 2:{
//            NSString *str1 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[0]];
//            [_img1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"6464.jpg"]];
//            NSString *str2 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[1]];
//            [_img2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"6464.jpg"]];
//            _img3.hidden = YES;
//        }
//            break;
//        default:
//            if (array.count>=3) {
//                NSString *str1 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[0]];
//                [_img1 sd_setImageWithURL:[NSURL URLWithString:str1] placeholderImage:[UIImage imageNamed:@"6464.jpg"]];
//                NSString *str2 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[1]];
//                [_img2 sd_setImageWithURL:[NSURL URLWithString:str2] placeholderImage:[UIImage imageNamed:@"6464.jpg"]];
//                NSString *str3 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[2]];
//                [_img3 sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"6464.jpg"]];
//            }
//            break;
//    }
    
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

- (void)setValueData:(id)model
{
    [super setValueData:model];
//    NSArray *array = [model.mb_dynamic_img componentsSeparatedByString:@","];
    NSArray *array;
    self.img3.hidden = NO;
    self.img6.hidden = NO;
    switch (array.count) {
        case 4:{
//            NSString *str1 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str2 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str4 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[2]];
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str5 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[3]];
            [self.img5 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            self.img3.hidden = YES;
            self.img6.hidden = YES;
        }
            break;
        case 5:{
//            NSString *str1 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str2 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str3 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[2]];
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str4 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[3]];
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str5 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[4]];
            [self.img5 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
            self.img6.hidden = YES;
        }
            break;
        case 6:{
//            NSString *str1 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str2 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str3 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[2]];
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str4 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[3]];
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str5 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[4]];
            [self.img5 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
//            NSString *str6 = [NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicimg,array[5]];
            [self.img6 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"zwt_lie"]];
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

@implementation LsDynamicTableViewCell_Video

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setValueData:(id)model
{
    [super setValueData:model];
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    NSString *file = [NSString stringWithFormat:@"voideCaches/%@",model.mb_dynamic_voide];
//    NSURL *filePath = [documentsDirectoryURL URLByAppendingPathComponent:model.mb_dynamic_voide];

//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *voideCachesPath = [[paths lastObject] stringByAppendingString:@"/voideCaches/"];
//    NSString *filePath = [voideCachesPath stringByAppendingString:model.mb_dynamic_voide];
//    if (![self fileExistsAtPath:filePath]) {
//
//        [_playView showHUDDeterminat];
//        [XCNetworking XC_Down_UploadWithUrl:[NSString stringWithFormat:@"%@%@%@",Ls_url_avatar_base,Ls_dynamicvoide,model.mb_dynamic_voide]
//                                   FileName:model.mb_dynamic_voide
//                                   Progress:^(CGFloat Progress) {
//                                       [_playView HUDProgress:Progress];
//                                   }
//                                    success:^(id filePath) {
//                                        [_playView hideHud];
//                                        if ([self fileExistsAtPath:[filePath relativePath]]) {
//                                            _playView.videoPath = [filePath relativePath];
//
//                                        }
//                                    }
//                                       fail:^(NSError *error) {
//                                           [_playView hideHud];
//                                           LogLoc(@"%@ 下载失败",model.mb_dynamic_voide);
//                                       }];
//    }else {
//        _playView.videoPath = filePath;
//        
//    }
//    
    
}

- (IBAction)playAction:(id)sender {
    
//    [TrVidoePlayView playVideo:@"" Thum:@"" From:_imgthum];
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
@end
