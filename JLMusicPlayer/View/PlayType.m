//
//  PlayType.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/11.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "PlayType.h"

@implementation PlayType

-(void)dealloc
{
    [_single release];
    [_order release];
    [_random release];
    self.delegate = nil;
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.single = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.single setImage:[UIImage imageNamed:@"danqu1"] forState:UIControlStateNormal];
        [self.single setImage:[UIImage imageNamed:@"danqu"] forState:UIControlStateSelected];
        [self.single addTarget:self action:@selector(singleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.single];
        
        self.order = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.order setImage:[UIImage imageNamed:@"shunxu1"] forState:UIControlStateNormal];
        [self.order setImage:[UIImage imageNamed:@"shunxu"] forState:UIControlStateSelected];
        [self.order addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.order];
        
        self.random = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.random setImage:[UIImage imageNamed:@"suiji1"] forState:UIControlStateNormal];
        [self.random setImage:[UIImage imageNamed:@"suiji"] forState:UIControlStateSelected];
        [self.random addTarget:self action:@selector(randomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.random];
    }
    
    return self;
}

-(void)layoutSubviews
{
    self.single.frame = CGRectMake(0, 0, 40, 40);
    self.order.frame = CGRectMake((self.frame.size.width - 120) / 2 + 40 , 0, 40, 40);
    self.random.frame = CGRectMake((self.frame.size.width - 120) + 80, 0, 40, 40);
    
}


-(void)singleButtonClick:(UIButton *)sender
{
    if (sender.selected) {
        
        sender.selected = NO;
        self.order.selected = NO;
        self.random.selected = NO;
        
    } else {
        
        sender.selected = YES;
        self.order.selected = NO;
        self.random.selected = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(singlePlay:)]) {
        
        [self.delegate singlePlay:sender.selected];
    }
}

-(void)orderButtonClick:(UIButton *)sender
{
    if (sender.selected) {
        
        sender.selected = NO;
        self.single.selected = NO;
        self.random.selected = NO;
        
    } else {
        
        sender.selected = YES;
        self.single.selected = NO;
        self.random.selected = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderPlay:)]) {
        
        [self.delegate orderPlay:sender.selected];
    }
}

-(void)randomButtonClick:(UIButton *)sender
{
    if (sender.selected) {
        
        sender.selected = NO;
        self.order.selected = NO;
        self.single.selected = NO;
        
    } else {
        
        sender.selected = YES;
        self.order.selected = NO;
        self.single.selected = NO;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(randomPlay:)]) {
        
        [self.delegate randomPlay:sender.selected];
    }
}














@end
