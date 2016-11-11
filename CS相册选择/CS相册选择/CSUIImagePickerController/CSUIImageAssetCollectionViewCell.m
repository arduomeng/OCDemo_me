//
//  CSUIImageAssetCollectionViewCell.m
//  CS相册选择
//
//  Created by arduomeng on 16/11/10.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "CSUIImageAssetCollectionViewCell.h"
#import <Photos/Photos.h>
#import "CSAssetModel.h"
@interface CSUIImageAssetCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoIcon;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation CSUIImageAssetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(CSAssetModel *)model{
    _model = model;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact; // 图像尺寸精确
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        // 该block会回调多次，苹果会先返回较小尺寸的image，作为暂时的显示
        self.imageView.image = result;
        
    }];
    
    if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        self.videoIcon.hidden = NO;
        self.durationLabel.hidden = NO;
        NSString *timeLength = [NSString stringWithFormat:@"%0.0f",model.asset.duration];
        timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
        [self.durationLabel setText:timeLength];
    }else{
        self.videoIcon.hidden = YES;
        self.durationLabel.hidden = YES;
    }
}

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

@end
