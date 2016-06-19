//
//  HMMusicsViewController.m
//  03-黑马音乐
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMMusicsViewController.h"
#import "MJExtension.h"
#import "HMMusic.h"
#import "UIImage+NJ.h"
#import "Colours.h"
#import "HMPlayingViewController.h"
#import "HMMusicsTool.h"

@interface HMMusicsViewController ()

// 播放界面
@property (nonatomic, strong) HMPlayingViewController *playingVc;
@end

@implementation HMMusicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HMMusicsTool musics] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     // 1.创建cell
     static NSString *identifier = @"music";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
     }
     // 2.设置数据
    HMMusic *music = [HMMusicsTool musics][indexPath .row];
    cell.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:5 borderColor:[UIColor skyBlueColor]];
    
     cell.textLabel.text = music.name;
     cell.detailTextLabel.text = music.singer;
    
     // 3.返回cell
     return cell;

}
// 选中某一个行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.主动取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 3.设置当前播放的音乐
    HMMusic *music = [HMMusicsTool musics][indexPath.row];
    [HMMusicsTool setPlayingMusic:music];
    
    [self.playingVc show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark - 懒加载
- (HMPlayingViewController *)playingVc
{
    if (!_playingVc) {
        self.playingVc = [[HMPlayingViewController alloc] init];
    }
    return _playingVc;
}
@end
