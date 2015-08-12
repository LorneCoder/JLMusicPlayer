//
//  MusicList.m
//  JLMusicPlayer
//
//  Created by JLItem on 15/7/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "MusicList.h"
#import "MusicModel.h"
#import "AudioPlayer.h"
#import "MusicListCell.h"
#import "UIImageView+WebCache.h"

#define kMusicUrl @"http://project.JLItem.com/teacher/UIAPI/MusicInfoList.plist"


@interface MusicList () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation MusicList

-(void)dealloc
{
    [_tableView release];
    [_dataArray release];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    
    [self requestData];
    [self readingView];
    
}

#pragma mark -数据请求-
-(void)requestData
{
    NSURL *url = [NSURL URLWithString:kMusicUrl];
    NSArray *array = [NSArray arrayWithContentsOfURL:url];
    for (NSDictionary *dict in array) {
        
        MusicModel *model = [[MusicModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dict];
        
        [self.dataArray addObject:model];
        
        [model release];
    }
    
    
}

#pragma mark -加载视图-
-(void)readingView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
}

#pragma mark -tableView delegate-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.nameLable.text = [self.dataArray[indexPath.row] name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bigImageView.layer.cornerRadius = 35;
    cell.bigImageView.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor blackColor];
    [cell.bigImageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray[indexPath.row] picUrl]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioPlayer *player = [[AudioPlayer alloc] init];
    
    player.musicIndex = indexPath.row;

    player.musicArray = [NSMutableArray arrayWithArray:self.dataArray];
    
    [self presentViewController:player animated:YES completion:^{
        
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
