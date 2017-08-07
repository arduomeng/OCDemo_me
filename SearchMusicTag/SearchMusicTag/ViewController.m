//
//  ViewController.m
//  SearchMusicTag
//
//  Created by user on 2017/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"
#import "MusicTagLibraryView.h"
#import "MusicTagTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, MusicTagTableViewCellDelegate>

@property (strong, nonatomic) UITableView *mainTableView;

@property (strong, nonatomic) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MusicTagLibraryView *tagLibraryView = [[MusicTagLibraryView alloc] initWithFrame:CGRectMake(10, 100, 200, 60)];
    tagLibraryView.backgroundColor = [UIColor purpleColor];
    tagLibraryView.musicTagsArr = @[@"tag1", @"tag2", @"tag3", @"tag4", @"tag5", @"tag6", @"tag7", @"tag8", @"tag9", @"tag10"];
    
//    [self.view addSubview:tagLibraryView];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    
    _mainTableView.estimatedRowHeight = 300;
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    
    [_mainTableView registerClass:[MusicTagTableViewCell class] forCellReuseIdentifier:@"MusicTagTableViewCell"];
    [self.view addSubview:_mainTableView];
    
    _array = @[
               @[@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff",@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff"],
               @[@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff"],
               @[@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff",@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff"],
               @[@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff"],
               @[@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff",@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff",@"aaaaaa", @"bb", @"ccc", @"ddd", @"ffffffffffffffffffffffff"],
               ];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _mainTableView.frame = self.view.bounds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicTagTableViewCell"];
    cell.delegate = self;
//    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor purpleColor];
    [cell setMusicTagsArr:_array[indexPath.row] section:indexPath.section];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)musicTagTableViewCell:(MusicTagTableViewCell *)cell OnclickButton:(MusicTagButton *)button{
    NSLog(@"%@ %ld %ld", button.title, button.section, button.tag);
}


@end
