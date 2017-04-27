//
//  TrVidoePlayView.m
//  Tourism_Tr
//
//  Created by lecochao on 2017/3/30.
//  Copyright © 2017年 yunduan. All rights reserved.
//

#import "TrVidoePlayView.h"

@implementation TrVidoePlayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    self.alpha = 0.2f;
    [self moveDown];
    
}

+(void)playVideo:(NSURL *)videoUrl
            Thum:(NSString *)thumUrl
            From:(UIImageView *)view
{
    TrVidoePlayView *player = [[TrVidoePlayView alloc]initWith:view];
    player.thumUrl = thumUrl;
    player.videoUrl = videoUrl;
    player.original = [[view superview] convertRect:view.frame toView:player];;
    [kKeyWindow addSubview:player];
}

-(instancetype)initWith:(UIImageView *)formView
{
    self = [super init];
    if (self) {
        self.frame = kKeyWindow.bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveUp)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setOriginal:(CGRect)original
{
    _original = original;
    _formView = [[UIImageView alloc]initWithFrame:_original];
    if ([_thumUrl rangeOfString:@"http"].location == NSNotFound) {
        _formView.image = [UIImage imageWithContentsOfFile:_thumUrl];
    }else
        [_formView sd_setImageWithURL:[NSURL URLWithString:_thumUrl]];
    
//    _formView.contentMode = UIViewContentModeCenter;
    _formView.layer.masksToBounds = YES;
    [self addSubview:_formView];
}

- (KZVideoPlayer *)player
{
    if (!_player) {
        CGFloat hh = CGRectGetWidth(KBounds)*3.0/4;
        CGRect frame = CGRectMake(0, (CGRectGetHeight(KBounds)-hh)/2.0, CGRectGetWidth(KBounds), hh);
        _player = [[KZVideoPlayer alloc] initWithFrame:frame videoUrl:_videoUrl];
        [self addSubview:_player];
    }
    return _player;
}

- (void)moveDown
{
    CGFloat hh = CGRectGetWidth(KBounds)*3.0/4;
    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 1;
        _formView.frame = CGRectMake(0, (CGRectGetHeight(KBounds)-hh)/2.0, CGRectGetWidth(KBounds), hh);
    } completion:^(BOOL finished) {
        self.player.hidden = NO;
    }];
}

- (void)moveUp
{
    [self.player stop];
    self.player.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _formView.frame = _original;
        self.alpha = 0.8f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.1f;
        }  completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.player = nil;
        }];
    }];
}

- (void)dealloc {
    self.player = nil;
}
@end
