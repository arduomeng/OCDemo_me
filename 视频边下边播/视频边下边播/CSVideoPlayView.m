//
//  CSVideoPlayView.m
//  VideoEdit
//
//  Created by arduomeng on 16/11/30.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "CSVideoPlayView.h"
#import "CSFullVideoPlayViewController.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>


#import "CSResourceLoader.h"

@interface CSVideoPlayView () <CSResourceLoaderDelegate>


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

/** AVURLAsset */
@property (nonatomic,strong) AVURLAsset *urlAsset;

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

/* 等待指示器 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;

/* 进度 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/* 资源解析 */
@property (nonatomic, strong) CSResourceLoader *resourceLoader;

// 标记
@property (nonatomic, assign) BOOL isBuffering;
#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)sliderTouchDown:(UISlider *)sender;
- (IBAction)sliderTouchUp:(UISlider *)sender;
- (IBAction)sliderValueChange:(UISlider *)sender;
- (IBAction)onclickFullBtn:(UIButton *)sender;


@end

@implementation CSVideoPlayView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // UI
    self.progressView.progress = 0;
    self.progressSlider.value = 0;
    self.activityView.hidden = NO;
    self.replayBtn.hidden = YES;
    [self.activityView startAnimating];
    
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

#pragma public method
- (void)setUrl:(NSURL *)url{
    
    _url = url;
    
    // When you replace or allocate a new object for a member, you're releasing the old object, so you need to remove the observer first :
    if (_playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    
    NSString *urlStr = [url absoluteString];
    // 本地视频
    if (![urlStr hasPrefix:@"http"]) {
        
    }
    //采用resourceLoader给播放器补充数据
    else {
        
        _resourceLoader = [[CSResourceLoader alloc] init];
//        self.resourceLoader.delegate = self;
        NSURL *playUrl = [Util getSchemeVideoURL:url];
        _urlAsset = [AVURLAsset URLAssetWithURL:playUrl options:nil];
        [_urlAsset.resourceLoader setDelegate:_resourceLoader queue:dispatch_get_main_queue()];
        _resourceLoader.delegate = self;
        _playerItem = [AVPlayerItem playerItemWithAsset:_urlAsset];
        
        // 替换playerItem (点击重播后，此处卡死，未找到原因)
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
        
    }
    
    // 添加观察者 playerItem准备就绪
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 播放器可用的数据
    [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];// 缓冲为空
    [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];// 视频可以播放
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

#pragma mark private method
- (void)play{
    [_player play];
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
}
- (void)pause{
    [_player pause];
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}


- (void)calculateDownloadProgress:(AVPlayerItem *)playerItem
{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
    CMTime duration = playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    [_progressView setProgress:timeInterval / totalDuration animated:YES];
}

- (void)bufferingSomeSecond
{
    
    
    if (!_isBuffering) {
        return;
    }
    
    [self pause];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.playOrPauseBtn.selected) {
            _isBuffering = NO;
            return;
        }
        // 在缓冲数据时, 为了防止播放器在等待数据时间过长时无法唤醒, 所以每隔一段时间就唤醒一次播放器.
        [self.player play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }else{
            [self.activityView stopAnimating];
            self.activityView.hidden = YES;
        }
    });
}

#pragma mark - 事件方法

- (IBAction)onClickReplayBtn:(id)sender {
    self.replayBtn.hidden = YES;
    
    // 重新加载视频
    [self setUrl:_url];
}

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
            
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
        }else{
            
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        [self calculateDownloadProgress:playerItem];
        
    }
    //  playbackBufferEmpty会反复进入
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem.isPlaybackBufferEmpty){
            
            _isBuffering = YES;
            [self pause];
            [self bufferingSomeSecond];
        }
        
    }
    // 缓冲达到可播放程度
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        if (_playerItem.playbackLikelyToKeepUp){
            _isBuffering = NO;
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


#pragma mark lazy

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

#pragma mark CSResourceLoaderDelegate

- (void)didFailLoadingWithResourceLoader:(CSResourceLoader *)resourceLoader{
    self.replayBtn.hidden = NO;
}


@end
