//
//  MusicPlayer.h
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AudioPlayer : UIViewController

@property (nonatomic, assign) NSInteger musicIndex;
@property (nonatomic, retain) NSMutableArray *musicArray;

@end
