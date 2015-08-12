//
//  MusicModel.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
/**
 *   @property (nonatomic, copy) NSString *mp3Url;
     @property (nonatomic,copy) NSString *name;
     @property (nonatomic,copy) NSString *picUrl;
     @property (nonatomic,copy) NSString *blurPicUrl;
     @property (nonatomic,copy) NSString *album;
     @property (nonatomic,copy) NSString *singer;
     @property (nonatomic,copy) NSString *musicDuration;
     @property (nonatomic,copy) NSString *artists_name;
     @property (nonatomic,copy) NSString *lyric;
 */

-(void)dealloc
{
    [_mp3Url release];
    [_name release];
    [_picUrl release];
    [_blurPicUrl release];
    [_album release];
    [_singer release];
    [_musicDuration release];
    [_artists_name release];
    [_lyric release];
    [super dealloc];
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"duration"]) {
        
        self.musicDuration = value;
    }
    
}


@end
