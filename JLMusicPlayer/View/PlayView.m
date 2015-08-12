//
//  PlayView.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

-(void)dealloc
{
    [_playButton release];
    [_upButton release];
    [_downButton release];
    Block_release(_playblock);
    Block_release(_upBlock);
    Block_release(_downButton);
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        
        self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.upButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
        [self.upButton addTarget:self action:@selector(upButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.upButton];
        
        self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.downButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [self.downButton addTarget:self action:@selector(downButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.downButton];

    }

    return self;
}

-(void)layoutSubviews
{
    self.upButton.frame = CGRectMake(0, 0, 40, 40);
    self.playButton.frame = CGRectMake((self.frame.size.width - 120) / 2 + 40, 0, 40, 40);
    self.downButton.frame = CGRectMake((self.frame.size.width - 120) + 80, 0, 40, 40);
}

-(void)playButtonClickAction:(UIButton *)sender
{
    self.playblock(sender.selected);
    
    if (sender.selected) {
        
        sender.selected = NO;

    } else {
        
        sender.selected = YES;
    }
    
}

-(void)upButtonClickAction
{

    self.upBlock();
    
}

-(void)downButtonClickAction
{
    
    self.downBlock();
    
}







@end
