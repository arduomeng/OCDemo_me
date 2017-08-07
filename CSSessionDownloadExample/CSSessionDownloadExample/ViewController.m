//
//  ViewController.m
//  CSSessionDownloadExample
//
//  Created by user on 2017/5/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"
#import "CSSessionDownloadManager.h"
#import "MainTableViewCell.h"
#import "MaterialModel.h"
#import "CSUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#define materialDIR [[CSUtil documentDirectory] stringByAppendingPathComponent:@"CSSessionDownload"]

@interface ViewController () <UITableViewDelegate ,UITableViewDataSource, MainTableViewCellDelegate, CSSessionDownloadManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) AVPlayerViewController *playerVC;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray array];
    MaterialModel *model1 = [[MaterialModel alloc] init];
    model1.url = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    [_dataArr addObject:model1];
    MaterialModel *model2 = [[MaterialModel alloc] init];
    model2.url = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
    [_dataArr addObject:model2];
    MaterialModel *model3 = [[MaterialModel alloc] init];
    model3.url = @"http://120.25.226.186:32812/resources/videos/minion_03.mp4";
    [_dataArr addObject:model3];
    MaterialModel *model4 = [[MaterialModel alloc] init];
    model4.url = @"http://120.25.226.186:32812/resources/videos/minion_04.mp4";
    [_dataArr addObject:model4];
    MaterialModel *model5 = [[MaterialModel alloc] init];
    model5.url = @"http://120.25.226.186:32812/resources/videos/minion_05.mp4";
    [_dataArr addObject:model5];
    MaterialModel *model6 = [[MaterialModel alloc] init];
    model6.url = @"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4";
    [_dataArr addObject:model6];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    [CSSessionDownloadManager shareInstance].delegate = self;
    [CSUtil createDirectoryIfNotExists:materialDIR];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = _dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MaterialModel *model = _dataArr[indexPath.row];
    NSString *desPath = [NSString stringWithFormat:@"%@/%@", materialDIR, [model.url componentsSeparatedByString:@"/"].lastObject];
   
    //视频播放的url
    NSURL *playerURL = [NSURL fileURLWithPath:desPath];
    
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:playerURL];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)MainTableViewCellOnclickDelete:(MainTableViewCell *)cell{
    
    NSString *desPath = [NSString stringWithFormat:@"%@/%@", materialDIR, [cell.model.url componentsSeparatedByString:@"/"].lastObject];
    [[CSSessionDownloadManager shareInstance] removeFileWith:desPath];
    
}

- (void)MainTableViewCellOnclick:(MainTableViewCell *)cell resume:(BOOL)resume{
    CSSessionDownloadManager *mgr = [CSSessionDownloadManager shareInstance];
    if (resume) {
        NSString *desPath = [NSString stringWithFormat:@"%@/%@", materialDIR, [cell.model.url componentsSeparatedByString:@"/"].lastObject];
        mgr.tag = cell.model.url;
        [mgr downloadDataWithURL:[NSURL URLWithString:cell.model.url] desPath:desPath resume:YES progress:nil status:nil];
    }else{
        [mgr downloadDataWithURL:[NSURL URLWithString:cell.model.url] desPath:nil resume:NO progress:nil status:nil];
    }
}


- (void)CSSessionDownloadManagerDidReceiveProgress:(float)progress download:(CSSessionDownload *)download{
    
    MaterialModel *model = [self matchModelWith:download.downloadTask.currentRequest.URL.absoluteString];
    if (model) {
        model.progress = download.downloadProgress;
        model.speed = download.downloadSpeed / 1024;
        model.statusType = StatusTypeDownloading;
        
        [self.mainTableView reloadData];
        
        NSLog(@"%f" , progress);
    }
    
}


- (void)CSSessionDownloadManagerDidRequestFail:(CSSessionDownload *)download{
    
    MaterialModel *model = [self matchModelWith:download.downloadTask.currentRequest.URL.absoluteString];
    if (model) {
        model.statusType = StatusTypeNeedDownload;
        
        [self.mainTableView reloadData];
        
        // 存下载进度
    }
}
- (void)CSSessionDownloadManagerDidRequestFinish:(CSSessionDownload *)download{
    MaterialModel *model = [self matchModelWith:download.downloadTask.currentRequest.URL.absoluteString];
    if (model) {
        model.statusType = StatusTypeFinished;
        
        [self.mainTableView reloadData];
        
        // 存下载完成
    }
}

- (MaterialModel *)matchModelWith:(NSString *)urlStr{
    for (MaterialModel *model in _dataArr) {
        if ([model.url isEqualToString:urlStr]) {
            return model;
        }
    }
    return nil;
}

@end
