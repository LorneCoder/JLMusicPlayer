//
//  MusicListCell.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/11.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "MusicListCell.h"

@implementation MusicListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_bigImageView release];
    [_nameLable release];
    [super dealloc];
}
@end
