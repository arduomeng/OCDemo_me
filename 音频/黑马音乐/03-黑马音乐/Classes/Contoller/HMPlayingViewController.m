//
//  HMPlayingViewController.m
//  03-黑马音乐
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMPlayingViewController.h"
#import "UIView+Extension.h"
#import "HMAudioTool.h"
#import "HMMusicsTool.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Extension.h"

@interface HMPlayingViewController ()<AVAudioPlayerDelegate>
/**
 * 退出
 */
- (IBAction)exitBtnClick:(UIButton *)sender;

/**
*  歌曲大图
*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**
 *  歌曲名称
 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/**
 *  歌手名称
 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

/**
 *  当前正在播放的音乐
 */
@property (nonatomic, strong) HMMusic *playingMusic;


/**
 *  当前播放器
 */
@property (nonatomic, strong) AVAudioPlayer *player;
/**
 *  时长
 */
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
/**
 *  获取进度定时器
 */
@property (nonatomic, strong) NSTimer *progressTimer;
/**
 *  开启定时器
 */
- (void)addProgressTimer;
/**
 *  移除定时器
 */
- (void)removeProgressTimer;

/**
 *  滑块
 */
@property (weak, nonatomic) IBOutlet UIButton *slider;
/**
 *  蓝色播放进度
 */
@property (weak, nonatomic) IBOutlet UIView *progressView;
/**
 *  监听进度条的点击
 */
- (IBAction)onProgressBgTap:(id)sender;
- (IBAction)onPanSlider:(UIPanGestureRecognizer *)sender;


/**
 *  显示时间小方块
 */
@property (weak, nonatomic) IBOutlet UIButton *currentTimeView;


/**
 *  上一首
 */
- (IBAction)previous;
/**
 *  下一首
 */
- (IBAction)next;
/**
 *  播放暂停
 */
- (IBAction)playOrPause;
/**
 *  播放暂停按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@end

@implementation HMPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTimeView.layer.cornerRadius = 8;
}
#pragma mark - 全局内部方法
- (void)show
{
    // 0.判断是否切换歌曲
    if(self.playingMusic != [HMMusicsTool playingMusic])
    {
        // 重置数据
        [self resetPlayingMusic];
    }
    
    // 1. 拿到Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 2. 设置当前控制器的frame
    self.view.frame = window.bounds;
    // 3. 将当前控制器的view添加到Window上
    [window addSubview:self.view];
    self.view.hidden = NO;
    
    // 禁用交互功能
    window.userInteractionEnabled = NO;
    
    // 4.执行动画, 让控制器的view从下面转出来
    self.view.y = window.bounds.size.height;
    [UIView animateWithDuration:1 animations:^{
        // 执行动画
        self.view.y = 0;
    } completion:^(BOOL finished) {
        // 开启交互
        window.userInteractionEnabled = YES;
        
        // 开始播放
        [self startPlayingMusic];
    }];
}

- (IBAction)exitBtnClick:(UIButton *)sender
{
    // 停止定时器
    [self removeProgressTimer];
    
    // 1. 拿到Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 禁用交互功能
    window.userInteractionEnabled = NO;
    
    // 2.执行退出动画
    [UIView animateWithDuration:1 animations:^{
        self.view.y = window.bounds.size.height;
        
    } completion:^(BOOL finished) {
        
        // 隐藏控制器的view
        self.view.hidden = YES;
        
        // 开启交互
        window.userInteractionEnabled = YES;
    }];
}


// 重置数据
- (void)resetPlayingMusic
{
    // 停止定时器
    [self removeProgressTimer];
    
    // 设置歌手
    self.singerLabel.text = nil;
    // 歌曲名称
    self.songLabel.text = nil;
    // 背景大图
    self.iconView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    
    // 停止当前正在播放的歌曲
    [HMAudioTool stopMusicWithFilename:self.playingMusic.filename];
}

// 开始播放
- (void)startPlayingMusic
{
    
    
    // 执行动画完毕, 开始播放音乐
    // 1.取出当前正在播放的音乐模型
    HMMusic *music = [HMMusicsTool playingMusic];
    // 2.播放音乐
    self.player = [HMAudioTool playMusicWithFilename:music.filename];
    self.player.delegate = self;
    
    self.playOrPauseButton.selected = YES;
    
    if (self.playingMusic == [HMMusicsTool playingMusic]) {
        NSLog(@"仅开启定时器");
        // 4.开始获取进度
        [self addProgressTimer];
        return;
    }
    
    // 记录当前正在播放的音乐
    self.playingMusic = [HMMusicsTool playingMusic];

    // 3.设置其他属性
    // 设置歌手
    self.singerLabel.text = music.singer;
    // 歌曲名称
    self.songLabel.text = music.name;
    // 背景大图
    self.iconView.image = [UIImage imageNamed:music.icon];
    // 设置总时长
    self.durationLabel.text = [self strWithTimeInterval:self.player.duration];
    
    // 4.开始获取进度
    [self addProgressTimer];
}

// 将秒转换为指定格式的字符串
- (NSString *)strWithTimeInterval:(NSTimeInterval)interval
{
    int m = interval / 60;
    int s = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d: %02d", m , s];
}

#pragma mark - 内部控制器方法
/**
 *  开启定时器
 */
- (void)addProgressTimer
{
    // 1.判断是否正在播放音乐
    if(self.player.playing == NO) return;
    
    // 保证数据同步, 立即更新
    [self updateCurrentProgress];
    
    // 2.创建定时器
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentProgress) userInfo:nil repeats:YES];
    // 3.将定时器添加到事件循环
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
/**
 *  移除定时器
 */
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

/**
 *  更新进度
 */
- (void)updateCurrentProgress
{
    
    // 1.计算进度
    double progress = self.player.currentTime / self.player.duration;
    
    // 2.获取滑块移动的最大距离
    double sliderMaxX = self.view.width - self.slider.width;
    
    // 3.设置滑块移动的位置
    self.slider.x = sliderMaxX * progress;
    
    // 4.设置蓝色进度条的宽度
    self.progressView.width = self.slider.center.x;
    
    // 5.设置滑块的标题
    [self.slider setTitle:[self strWithTimeInterval:self.player.currentTime] forState:UIControlStateNormal];
    
}

// 监听进度条点击事件
- (IBAction)onProgressBgTap:(UIGestureRecognizer *)sender {
    NSLog(@"%s", __func__);
    // 1.取出当前点击的位置
    CGPoint point =  [sender locationInView:sender.view];
    // 2.设置滑块的位置, 为点击的位置
    self.slider.x = point.x;
    // 3.计算进度
    double progress = point.x / sender.view.width;
    // 4.设置播放事件
    self.player.currentTime = progress * self.player.duration;
    // 5.立即更新
    [self updateCurrentProgress];
}

// 监听滑块拖拽事件
- (IBAction)onPanSlider:(UIPanGestureRecognizer *)sender
{

    // 1.获得当前拖拽的位置
    // 获取到滑块平移的位置
    CGPoint point =  [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 2.将滑块移动到拖拽的位置
    // 累加平移的位置
    self.slider.x += point.x;
    // 矫正移动的位置
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    NSLog(@"%f %f", sliderMaxX, self.slider.x);
    if (self.slider.x < 0) {
        self.slider.x = 0;
    } else if (self.slider.x > sliderMaxX) {
        self.slider.x = sliderMaxX;
    }
    
    
    // 3.设置蓝色进度条的宽度
    self.progressView.width = self.slider.center.x;
    
    // 计算当前拖拽到得指定位置
    double progress = self.slider.x / sliderMaxX;
    NSTimeInterval time = progress * self.player.duration;
    
    // 4.设置拖拽时滑块的标题
    [self.slider setTitle:[self strWithTimeInterval:time] forState:UIControlStateNormal];
    
    // 5.设置显示进度的方块的内容
    [self.currentTimeView setTitle:[self strWithTimeInterval:time] forState:UIControlStateNormal];
    
    // 6.设置显示进度的方块的frame
    self.currentTimeView.x = self.slider.x;
    self.currentTimeView.y = self.currentTimeView.superview.height - self.currentTimeView.height - 10;
    
    // 3.判断当前收拾的状态
    // 如果是开始拖拽就停止定时器, 如果结束拖拽就开启定时器
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        // 显示进度的方块
        self.currentTimeView.hidden = NO;
        
        // 开始拖拽
        NSLog(@"开始拖拽, 停止定时器");
        [self removeProgressTimer];
        
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
         // 隐藏显示进度的方块
        self.currentTimeView.hidden = YES;
        
        self.player.currentTime  = time;
        
        // 结束拖拽
        if (self.player.playing) {
            NSLog(@"结束拖拽, 开启定时器");
            [self addProgressTimer];
        }
    }
}

/**
 *  上一首
 */
- (IBAction)previous
{
    // 1.重置数据
    [self resetPlayingMusic];
    // 2.设置当前播放的音乐
    [HMMusicsTool setPlayingMusic:[HMMusicsTool previouesMusic]];
    // 3.开始播放
    [self startPlayingMusic];
}
/**
 *  下一首
 */
- (IBAction)next
{
    // 1.重置数据
    [self resetPlayingMusic];
    // 2.设置当前播放的音乐
    [HMMusicsTool setPlayingMusic:[HMMusicsTool nextMusic]];
    // 3.开始播放
    [self startPlayingMusic];
}
/**
 *  播放暂停
 */
- (IBAction)playOrPause
{
    // 判断按钮当前的状态
    if (self.playOrPauseButton.selected)
    {
        // 选中, 显示的暂停-->显示播放
        self.playOrPauseButton.selected = NO;
        
        // 调用工具类方法暂停
        [HMAudioTool pauseMusicWithFilename:self.playingMusic.filename];
    }else
    {
        // 未选中, 显示播放-->显示的暂停
        self.playOrPauseButton.selected = YES;
        
//         调用工具类方法播放
//        [HMAudioTool playMusicWithFilename:self.playingMusic.filename];
//        // 开启定时器更新进度
//        [self addProgressTimer];
        
        [self startPlayingMusic];
    }
}

#pragma mark - AVAudioPlayerDelegate
// 播放结束时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 下一曲
    [self next];
}

// 播放器被打断时调用(例如电话)
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    // 暂停
    if (self.player.playing) {
        [HMAudioTool pauseMusicWithFilename:self.playingMusic.filename];
    }
}

// 播放器打断结束
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    // 继续播放
    if (!self.player.playing) {
        [self startPlayingMusic];
    }
}
@end
