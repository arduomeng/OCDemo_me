//
//  MainTableViewCell.h
//  CSSessionDownloadExample
//
//  Created by user on 2017/5/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialModel.h"

@class MainTableViewCell;
@protocol MainTableViewCellDelegate <NSObject>

- (void)MainTableViewCellOnclick:(MainTableViewCell *)cell resume:(BOOL)resume;
- (void)MainTableViewCellOnclickDelete:(MainTableViewCell *)cell;

@end

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (strong, nonatomic) MaterialModel *model;
@property (weak, nonatomic) id <MainTableViewCellDelegate> delegate;


@end
