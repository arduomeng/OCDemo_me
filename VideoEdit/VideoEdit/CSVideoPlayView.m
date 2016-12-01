//
//  CSVideoPlayView.m
//  VideoEdit
//
//  Created by arduomeng on 16/11/30.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "CSVideoPlayView.h"
#import "CSFullVideoPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface CSVideoPlayView ()


/** 背景图片 */
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/** 工具栏     */
@property (strong, nonatomic) IBOutlet UIView *toolView;
/** 开始暂停按钮 */
@property (strong, nonatomic) IBOutlet UIButton *playOrPauseBtn;
/** 滑动条 */
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;
/** 时间Label*/
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

/** 播放器 */
@property (nonatomic,strong) AVPlayer *player;

/** 播放器的Layer */
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

/** playItem */
@property (nonatomic,strong) AVPlayerItem *playerItem;

/** 记录当前是否显示了工具栏 */
@property (nonatomic,assign) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

/* 工具栏的显示和隐藏 */
@property (nonatomic, strong) NSTimer *showTimer;

/* 工具栏展示的时间 */
@property (assign, nonatomic) NSTimeInterval showTime;

/* 全屏控制器 */
@property (nonatomic, strong) CSFullVideoPlayViewController *fullVc;

#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)sliderTouchDown:(UISlider *)sender;
- (IBAction)sliderTouchUp:(UISlider *)sender;
- (IBAction)sliderValueChange:(UISlider *)sender;
- (IBAction)onclickFullBtn:(UIButton *)sender;


@end

@implementation CSVideoPlayView

- (void)setUrl:(NSURL *)url{
    
    _url = url;
    
    // When you replace or allocate a new object for a member, you're releasing the old object, so you need to remove the observer first :
    if (_playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    _playerItem = [AVPlayerItem playerItemWithURL:url];
    
    // 替换playerItem
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    
    // 添加观察者 playerItem准备就绪
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)setOuterPlayerItem:(AVPlayerItem *)outerPlayerItem{
    // When you replace or allocate a new object for a member, you're releasing the old object, so you need to remove the observer first :
    if (_playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    _playerItem = outerPlayerItem;
    
    // 替换playerItem
    [_player replaceCurrentItemWithPlayerItem:_playerItem];
    
    // 添加观察者 playerItem准备就绪
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 初始化Player相关对象
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    // 设置进度条的内容
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    // 添加滑动手势
    UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureLeft:)];
    gestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRight:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_imageView addGestureRecognizer:gestureLeft];
    [_imageView addGestureRecognizer:gestureRight];
    
    // 添加通知监听 playerItem播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _playerLayer.frame = self.bounds;
}

#pragma mark - 事件方法

- (IBAction)playOrPause:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [_player play];
        [self addProgressTimer];
    }else{
        [_player pause];
        [self removeProgressTimer];
    }
    
}

- (void)sliderTouchUp:(UISlider *)sender{
    NSLog(@"sliderTouchUp");
    // 只有正在播放才添加定时器
    if (_player.rate > 0 && _player.error == nil) {
        [self addProgressTimer];
    }
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC)];
}

- (void)sliderTouchDown:(UISlider *)sender{
    NSLog(@"sliderTouchDown");
    [self removeProgressTimer];
}

- (void)sliderValueChange:(UISlider *)sender{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

- (IBAction)onclickFullBtn:(UIButton *)sender {
    
    if (sender.selected) {
        
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.contrainerViewController.view addSubview:self];
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = CGRectMake(0, 0, self.contrainerViewController.view.bounds.size.width, self.contrainerViewController.view.bounds.size.width * 9 / 16);
            } completion:nil];
        }];
    }else{
        
        [_contrainerViewController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self];
            self.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.fullVc.view.bounds;
            } completion:nil];
        }];
    }
    
    sender.selected = !sender.selected;
}

- (IBAction)swipeGestureLeft:(UISwipeGestureRecognizer *)sender {
    [self swipeToRight:NO];
}

- (IBAction)swipeGestureRight:(UISwipeGestureRecognizer *)sender {
    [self swipeToRight:YES];
}

- (void)swipeToRight:(BOOL)isRight
{
    // 1.获取当前播放的时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    if (isRight) {
        currentTime += 1;
    } else {
        currentTime -= 1;
    }
    
    if (currentTime >= CMTimeGetSeconds(self.player.currentItem.duration)) {
        currentTime = CMTimeGetSeconds(self.player.currentItem.duration) - 1;
    } else if (currentTime <= 0) {
        currentTime = 0;
    }
    
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, self.playerItem.asset.duration.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self updateProgressInfo];
}

#pragma 定时器
- (void)addProgressTimer{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
}
- (void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    self.progressSlider.value = CMTimeGetSeconds(_player.currentTime) / CMTimeGetSeconds(_player.currentItem.duration);
}
- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}
- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            // 准备就绪
            [self updateProgressInfo];
        }else{
            
        }
    }else{
        // 将KVO事件传递给父类
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 通知 
- (void)playerItemDidPlayToEndTime{
    // 播放完毕
    [self removeProgressTimer];
    [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC)];
    [self updateProgressInfo];
    self.playOrPauseBtn.selected = NO;
}


- (CSFullVideoPlayViewController *)fullVc{
    if (!_fullVc) {
        _fullVc = [[CSFullVideoPlayViewController alloc] init];
    }
    return _fullVc;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItem removeObserver:self forKeyPath:@"status"];
}

@end
