//
//  TrVidoePlayView.h
//  Tourism_Tr
//
//  Created by lecochao on 2017/3/30.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZVideoPlayer.h"

@interface TrVidoePlayView : UIView
@property(nonatomic ,strong) KZVideoPlayer *player;
@property(nonatomic ,strong) UIImageView *formView;
@property(nonatomic ,strong) NSURL *videoUrl;
@property(nonatomic ,strong) NSString *thumUrl;
@property(nonatomic ,assign) CGRect original;
+(void)playVideo:(NSURL *)videoUrl
            Thum:(NSString *)thumUrl
            From:(UIImageView *)view;
@end
