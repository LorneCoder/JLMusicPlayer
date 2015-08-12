//
//  Lyric.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/11.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "Lyric.h"


@implementation Lyric

-(void)dealloc
{
    [_lyricArray release];
    [_timeArray release];
    [super dealloc];
}



+(Lyric *)shareLyric
{
    static Lyric *lyric = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lyric = [[Lyric alloc] init];
    });
    
    return lyric;
}

-(void)lyricBaseModel:(MusicModel *)model
{
    //先拿到 整个歌词数据
    NSArray *mainArray = [NSArray array];
    mainArray = [model.lyric componentsSeparatedByString:@"\n"];
    
    NSMutableArray *timeArr1 = [NSMutableArray array];
    self.lyricArray = [NSMutableArray array];
    self.timeArray = [NSMutableArray array];
    
    
    for (int i = 0; i < mainArray.count - 1; i++) {
        
        NSArray *array1 = [mainArray[i] componentsSeparatedByString:@"]"];
        [timeArr1 addObject:array1[0]];
        [self.lyricArray addObject:array1[1]];
    }
    
    for (int i = 0; i < timeArr1.count; i++) {
        
        NSArray *array2 = [timeArr1[i] componentsSeparatedByString:@"["];
        
        [self.timeArray addObject:array2[1]];
    }
}

// 判断 某个时间内 tableView应该显示哪条数据
- (NSInteger)numOfLyricWithTime:(float)timer
{
    //将 self.timeArray 中的对象转为 跟timer 相同格式
    NSMutableArray *timeArr = [NSMutableArray array];
    NSMutableArray *haomiaoArr = [NSMutableArray array];
    
    for (int i = 0; i < self.timeArray.count; i++) {
        
        NSArray *arr1 = [self.timeArray[i] componentsSeparatedByString:@"."];
        
        [timeArr addObject:arr1[0]];
        [haomiaoArr addObject:arr1[1]];
    }
    
    for (int i = 0; i < timeArr.count; i++) {
        
        NSArray *arr2 = [timeArr[i] componentsSeparatedByString:@":"];
        
        float tempTime = [arr2[0] integerValue] * 60 + [arr2[1] floatValue] + [haomiaoArr[i] floatValue] / 1000 ;
        
        if (timer < tempTime) {
            
            //  因为有些歌曲下标的时间不是从0开始的， 所以 需要做一个安全性的验证
            if (i - 1 ==  -1) {
                // 如果给定的时间小于第一个元素，那么 直接返回0 防止越界
                return 0;
            } else {
                // 如果不是， 则返回 i - 1
                // 因为 当给定的时间大于等于数组中某个元素 才需要跳转，当小于的时候 需要保持上一句歌词 所以返回 i-1
                // 如果想不清楚 可以打印一下看看 根据i 去打印时间和歌词
                return i - 1;
            }
        }
    }
    return self.timeArray.count - 1;

}
















@end
