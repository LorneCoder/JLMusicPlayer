//
//  MusicPlayer.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicModel.h"
#import "PlayView.h"
#import "UIImageView+WebCache.h"
#import "Lyric.h"
#import "PlayerManager.h"
#import "PlayType.h"


@interface AudioPlayer () <UITableViewDelegate,UITableViewDataSource,AudioPlayerDelegate,PlayTypeDelegate>

@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) MusicModel *model;
@property (nonatomic, retain) UIImageView *picImageView;
@property (nonatomic, retain) UILabel *titleLable;
@property (nonatomic, retain) UILabel *singerLable;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, retain) UILabel *timeLable;
@property (nonatomic, retain) PlayType *typeView;

@end

@implementation AudioPlayer

-(void)dealloc
{
    [_backgroundImage release];
    [_musicArray release];
    [_model release];
    [_picImageView release];
    [_titleLable release];
    [_singerLable release];
    [_scrollView release];
    [_slider release];
    [_tableView release];
    [_timeLable release];
    [_typeView release];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [PlayerManager sharePlayerManager].delegate = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  AVPlayer
     */
    [self initAVPlayer];
    /**
     *  按钮的相关配置
     */
    [self creatButton];
    /**
       底视图 歌曲图片 歌曲名 歌手 进度条
     */
    [self musicInfo];
    /**
     *  tableView
     */
    [self creatTableView];
    /**
     *  通过单例类来展示歌词
     */
    [[Lyric shareLyric] lyricBaseModel:self.model];
    
}

#pragma mark -- 单例类的 代理方法 动态更改进度--
-(void)changeCurrentTime:(float)time
{
    self.slider.value = [PlayerManager sharePlayerManager].musicPlayer.currentTime.value / [PlayerManager sharePlayerManager].musicPlayer.currentTime.timescale;
    
    //将时间的秒数和slider的value关联起来
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.slider.value];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *str = [formatter stringFromDate:date];
    self.timeLable.text = str;
    [formatter release];
    
    //让歌曲大图 一直旋转
    self.picImageView.transform = CGAffineTransformRotate(self.picImageView.transform, M_PI_4 / 90);
    
    // 循环播放的模式
    if (self.slider.value == [self.model.musicDuration floatValue] / 1000) {
        
        if (self.typeView.single.selected) {
            
            [self singlePlay:YES];
            
        } else if (self.typeView.random.selected) {
            
            [self randomPlay:YES];
            
        } else {
         
            [self orderPlay:YES];
        }
    }
    
    // 实时的更新歌词的进度
    self.rowIndex = [[Lyric shareLyric] numOfLyricWithTime:self.slider.value];
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.rowIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -- 底视图 歌曲图片 歌曲名 歌手 --
-(void)musicInfo
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 450)];
    self.scrollView.contentSize = CGSizeMake(375 * 2, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;//隐藏滑动条
    [self.view addSubview:self.scrollView];
    [self.scrollView release];
    
    self.picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(88, 100, 200, 200)];
    self.picImageView.layer.cornerRadius = 100;
    self.picImageView.layer.masksToBounds = YES;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl]];
    //添加动画效果
    self.picImageView.transform = CGAffineTransformRotate(self.picImageView.transform, M_PI_4 / 90);
    [self.scrollView addSubview:self.picImageView];
    [self.picImageView release];
    
    self.titleLable = [[UILabel alloc] initWithFrame: CGRectMake(0, 350, 200, 30)];
    self.titleLable.text = self.model.name;
    self.titleLable.textColor = [UIColor purpleColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.titleLable];
    [self.titleLable release];
    
    self.singerLable = [[UILabel alloc] initWithFrame:CGRectMake(200, 350, 175, 30)];
    self.singerLable.textAlignment = NSTextAlignmentCenter;
    self.singerLable.text = self.model.singer;
    self.singerLable.textColor = [UIColor purpleColor];
    [self.scrollView addSubview:self.singerLable];
    [self.singerLable release];
    
    //进度条
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 460, 355, 30)];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = [self.model.musicDuration floatValue] / 1000;
    self.slider.value = 0;
    [self.slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    [self.slider release];

    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 490, 60, 30)];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.timeLable];
    [self.timeLable release];
    
}

#pragma mark -- AVPlayer 初始化--
-(void)initAVPlayer
{
    self.model = self.musicArray[self.musicIndex];

    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:self.model.blurPicUrl]];
    [self.view addSubview:self.backgroundImage];
    [self.backgroundImage release];
    
    //毛玻璃
    UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    backgroundView.frame = self.view.frame;
    [self.view addSubview:backgroundView];
    [backgroundView release];
    
    //单例类实现播放功能
    [PlayerManager sharePlayerManager].delegate = self;
    [PlayerManager sharePlayerManager].musicUrl = self.model.mp3Url;
    [[PlayerManager sharePlayerManager].musicPlayer play];
}

#pragma mark -- 按钮的配置 --
-(void)creatButton
{
    /**
     *  按钮的配置
     */
    PlayView *buttonView = [[PlayView alloc] initWithFrame:CGRectMake(75, 510, 225, 40)];
    [self.view addSubview:buttonView];
    
    // 播放、暂停
    buttonView.playblock = ^(BOOL isPlay){
        
        if (isPlay) {
            [[PlayerManager sharePlayerManager].musicPlayer play];
            //恢复动画
            [PlayerManager sharePlayerManager].timer.fireDate = [NSDate distantPast];
            
        } else {
            [[PlayerManager sharePlayerManager].musicPlayer pause];
            //暂停动画
            [PlayerManager sharePlayerManager].timer.fireDate = [NSDate distantFuture];
        }
    };
    
    //上一曲
    buttonView.upBlock = ^(){
        [self upMusic];
    };
    
    //下一曲
    buttonView.downBlock = ^(){
        [self downMusic];
    };
 
    /**
     *  播放状态 循环模式
     */
    self.typeView = [[PlayType alloc] initWithFrame:CGRectMake(20, 600, 335, 40)];
    [self.view addSubview:self.typeView];
    [self.typeView release];
    self.typeView.delegate = self;
}

#pragma mark -- 播放模式 --
//实现代理方法
//单曲循环
-(void)singlePlay:(BOOL)selected
{
    if (selected) {
    
        if (self.slider.value == [self.model.musicDuration floatValue] / 1000) {
            
            [PlayerManager sharePlayerManager].musicUrl = self.model.mp3Url;
            [[PlayerManager sharePlayerManager].musicPlayer play];
        }
    }
}

//顺序播放
-(void)orderPlay:(BOOL)selected
{
    if (selected) {
        
        if (self.slider.value == [self.model.musicDuration floatValue] / 1000) {
            
            [self downMusic];
        }
    }
}

//随机播放
-(void)randomPlay:(BOOL)selected
{
    if (selected) {
        
        if (self.slider.value == [self.model.musicDuration floatValue] / 1000) {
            
            NSInteger number = arc4random() % 200;
            NSLog(@"%ld",number);
            self.model = self.musicArray[number];
            //更改一下 歌曲信息
            [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:self.model.blurPicUrl]];
            [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl]];
            self.titleLable.text = self.model.name;
            self.singerLable.text = self.model.singer;
            self.slider.maximumValue = [self.model.musicDuration floatValue] / 1000;
            [[Lyric shareLyric] lyricBaseModel:self.model];
            
            [PlayerManager sharePlayerManager].musicUrl = self.model.mp3Url;
            [[PlayerManager sharePlayerManager].musicPlayer play];
        }
    }
}

#pragma mark --上一曲--
-(void)upMusic
{
    if (self.musicIndex == 0) {
        
        self.musicIndex = self.musicArray.count - 1;
    } else {
        
        self.musicIndex -= 1;
    }
    
    self.model = self.musicArray[self.musicIndex];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.model.mp3Url]];
    [[PlayerManager sharePlayerManager].musicPlayer replaceCurrentItemWithPlayerItem:playerItem];
    /**
     *  更换歌曲响应信息：图片、歌曲名、歌手、歌词、slider的最大值
     */
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:self.model.blurPicUrl]];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl]];
    self.titleLable.text = self.model.name;
    self.singerLable.text = self.model.singer;
    self.slider.maximumValue = [self.model.musicDuration floatValue] / 1000;

    [[Lyric shareLyric] lyricBaseModel:self.model];
    
}

#pragma mark -- 下一曲 --
-(void)downMusic
{
    if (self.musicIndex == self.musicArray.count - 1) {
        
        self.musicIndex = 0;
    } else {
        
        self.musicIndex += 1;
    }
    
    self.model = self.musicArray[self.musicIndex];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.model.mp3Url]];
    [[PlayerManager sharePlayerManager].musicPlayer replaceCurrentItemWithPlayerItem:playerItem];
    /**
     *  更换歌曲响应信息
     */
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:self.model.blurPicUrl]];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl]];
    self.titleLable.text = self.model.name;
    self.singerLable.text = self.model.singer;
    self.slider.maximumValue = [self.model.musicDuration floatValue] / 1000;
    
    [[Lyric shareLyric] lyricBaseModel:self.model];

}

#pragma mark -- slider的关联方法 --
-(void)sliderValueChanged
{
    [[PlayerManager sharePlayerManager].musicPlayer seekToTime:CMTimeMake(self.slider.value, 1)];
}

#pragma mark -- tableView --
-(void)creatTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(375, 64, 375, 450 - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏 单元格的分割线
    self.tableView.rowHeight = 70;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.scrollView addSubview:self.tableView];
    [self.tableView release];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Lyric shareLyric].lyricArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    //改变歌词颜色
    if (indexPath.row == self.rowIndex) {
        cell.textLabel.textColor = [UIColor greenColor];
    } else {
        cell.textLabel.textColor = [UIColor grayColor];
    }

    cell.textLabel.text = [Lyric shareLyric].lyricArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark -- 模态返回 --
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
