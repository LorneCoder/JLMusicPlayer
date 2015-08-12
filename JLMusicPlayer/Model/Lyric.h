//
//  Lyric.h
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/11.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

@interface Lyric : NSObject

@property (nonatomic, retain) NSMutableArray *lyricArray;
@property (nonatomic, retain) NSMutableArray *timeArray;

// 声明一个单例用来传值
+(Lyric *)shareLyric;

// 根据传入的数据模型 获取到 相应数据模型 对应的歌词数据信息
-(void)lyricBaseModel:(MusicModel *)model;

// 判断 某个时间内 tableView应该显示哪条数据
-(NSInteger)numOfLyricWithTime:(float)timer;


@end
