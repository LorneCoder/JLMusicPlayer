//
//  PlayerManager.h
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/11.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayerDelegate <NSObject>

@optional
-(void)changeCurrentTime:(float)time;
@end

@interface PlayerManager : NSObject

@property (nonatomic, retain) AVPlayer *musicPlayer;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, assign) id <AudioPlayerDelegate> delegate;

+(PlayerManager *)sharePlayerManager;
-(void)playMusic;
-(void)pauseMusic;

@end
