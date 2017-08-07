//
//  MusicTagTableViewCell.h
//  SearchMusicTag
//
//  Created by user on 2017/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicTagButton.h"

@class MusicTagTableViewCell;

@protocol MusicTagTableViewCellDelegate <NSObject>

- (void)musicTagTableViewCell:(MusicTagTableViewCell *)cell OnclickButton:(MusicTagButton *)button;

@end

@interface MusicTagTableViewCell : UITableViewCell

@property (strong, nonatomic) NSArray *musicTagsArr;
@property (assign, nonatomic) NSUInteger cellHeight;


@property (weak, nonatomic) id <MusicTagTableViewCellDelegate> delegate;

- (void)setMusicTagsArr:(NSArray *)musicTagsArr section:(NSInteger) section;

@end
