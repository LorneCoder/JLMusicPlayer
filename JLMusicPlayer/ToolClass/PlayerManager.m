//
//  PlayerManager.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/11.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "PlayerManager.h"

@interface PlayerManager ()

@end

@implementation PlayerManager

-(void)dealloc
{
    [_musicPlayer release];
    [_timer release];
    [_musicUrl release];
    self.delegate = nil;
    [super dealloc];
}

/**
 *  初始化 musicPlayer
 */
-(instancetype)init
{
    if (self = [super init]) {
        _musicPlayer = [[AVPlayer alloc] init];
    }
    return self;
}

/**
 *  重写 musicPlayer 的setter的方法
 */
-(void)setMusicUrl:(NSString *)musicUrl
{
    if (_musicUrl != musicUrl) {
        
        [_musicUrl release];
        _musicUrl = [musicUrl retain];
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:musicUrl]];
    [_musicPlayer replaceCurrentItemWithPlayerItem:playerItem];
    
    [self playMusic];
    [playerItem release];
}


+(PlayerManager *)sharePlayerManager
{
    static PlayerManager *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[PlayerManager alloc] init];
    });
    return player;
}

-(void)playMusic
{
    [self.musicPlayer play];
    [self creatTimer];
}

-(void)currentTimeChange
{
    CGFloat currentTime = self.musicPlayer.currentTime.value / self.musicPlayer.currentTime.timescale;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeCurrentTime:)]) {
        
        [self.delegate changeCurrentTime:currentTime];
    }
}

-(void)pauseMusic
{
    [self.musicPlayer pause];
    [self.timer invalidate];
    self.timer = nil;
}

// 可能会多次的创建timer 所以 单独写一个方法 去创建timer
- (void)creatTimer
{
    // 如果timer为空 则创建 如果不为空 就不创建了
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}
// timer触发的方法 ，每隔0.1秒触发一次
- (void)timerAction
{
    float progress = (float)self.musicPlayer.currentTime.value / (float)self.musicPlayer.currentTime.timescale;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeCurrentTime:)]) {
        // 每隔0.1秒 让代理人触发一次代理方法
        [self.delegate changeCurrentTime:progress];
    }
}


@end
