//
//  PlayView.h
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^playBlock)(BOOL isPlay);
typedef void (^Block)();

@interface PlayView : UIView

@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UIButton *upButton;
@property (nonatomic, retain) UIButton *downButton;

@property (nonatomic, copy) playBlock playblock;
@property (nonatomic, copy) Block upBlock;
@property (nonatomic, copy) Block downBlock;


@end
