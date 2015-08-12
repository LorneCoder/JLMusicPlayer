//
//  PlayType.h
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/11.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayTypeDelegate <NSObject>

@optional
-(void)singlePlay:(BOOL)selected;
-(void)orderPlay:(BOOL)selected;
-(void)randomPlay:(BOOL)selected;

@end


@interface PlayType : UIView

@property (nonatomic, retain) UIButton *single;//单曲
@property (nonatomic, retain) UIButton *order;//顺序
@property (nonatomic, retain) UIButton *random;//随机

@property (nonatomic, assign) id <PlayTypeDelegate> delegate;


@end
