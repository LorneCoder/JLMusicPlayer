//
//  MusicModel.h
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,copy) NSString *blurPicUrl;
@property (nonatomic,copy) NSString *album;
@property (nonatomic,copy) NSString *singer;
@property (nonatomic,copy) NSString *musicDuration;
@property (nonatomic,copy) NSString *artists_name;
@property (nonatomic,copy) NSString *lyric;



@end
