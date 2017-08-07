//
//  MainTableViewCell.m
//  CSSessionDownloadExample
//
//  Created by user on 2017/5/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import "MainTableViewCell.h"
#import "CSSessionDownloadManager.h"
@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MaterialModel *)model{
    _model = model;
    _speedLabel.text = [NSString stringWithFormat:@"%lld kb/s", model.speed];
    _progressView.progress = model.progress;
    
    switch (model.statusType) {
        case StatusTypeNeedDownload:
            self.startBtn.hidden = NO;
            self.deleteBtn.hidden = YES;
            self.startBtn.selected = NO;
            break;
        case StatusTypeFinished:
            
            self.startBtn.hidden = YES;
            self.deleteBtn.hidden = NO;
            break;
        case StatusTypeDownloading:
            
            self.startBtn.hidden = NO;
            self.deleteBtn.hidden = YES;
            self.startBtn.selected = YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)startBtnOnclick:(UIButton *)sender {
    // 下载
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [self.delegate MainTableViewCellOnclick:self resume:YES];
    }
    // 停止
    else{
        sender.selected = !sender.selected;
        [self.delegate MainTableViewCellOnclick:self resume:NO];
    }
}

- (IBAction)deleteBtnOnclick:(UIButton *)sender {
    [self.delegate MainTableViewCellOnclickDelete:self];
}

@end
