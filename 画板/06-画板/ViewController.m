//
//  ViewController.m
//  06-画板
//
//  Created by Gavin on 15/9/14.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "HandleImageView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,HandleImageViewDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@property(nonatomic,weak) UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)clear:(id)sender {
    [self.drawView clear];
}

- (IBAction)undo:(id)sender {
    [self.drawView undo];
}

//橡皮擦
- (IBAction)erase:(id)sender {
    
    [self.drawView erase];
    
}

//选择照片
- (IBAction)chosePic:(id)sender {
    
    //系统相册控制器
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    
    //设置照片的来源
    pickVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    //设置代理
    pickVC.delegate = self;
    //modal出系统相册控制器
    [self presentViewController:pickVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取当前选中的图片.通过UIImagePickerControllerOriginalImage就能获取.
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    HandleImageView *handView = [[HandleImageView alloc] init];
    handView.frame = self.drawView.bounds;
    handView.image = image;
    handView.delegate = self;

    
    NSLog(@"%@", handView.backgroundColor);
    [self.drawView addSubview:handView];
    
    //    self.drawView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//-(void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
//    NSLog(@"%@",info);
//    //从字典当中取出选择的图片
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    
//    HandleImageView *handView = [[HandleImageView alloc] init];
//    handView.frame = self.drawView.frame;
//    handView.image = image;
//    handView.delegate = self;
//    [self.view addSubview:handView];
//
////    self.drawView.image = image;
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    
//}

//HandleImageViewDelegate方法
//newImage:截取的图片.
-(void)handleImageView:(HandleImageView *)handleImageV newImage:(UIImage *)image{
    
    self.drawView.image = image;
    
}

//保存
- (IBAction)save:(id)sender {
    
    //1.把画板东西生成一张图片保存
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0);
    
     CGContextRef ctx =  UIGraphicsGetCurrentContext();
    
    [self.drawView.layer renderInContext:ctx];
    
    //生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文.
    UIGraphicsEndImageContext();
    
    //写到系统相册当中
    
    //注意,保存成功调用的方法必须得是
    //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    NSLog(@"保存成功");

}


- (void)saveSuccess{


}


//设置线的宽度
- (IBAction)valueChange:(UISlider *)sender {
    [self.drawView setLineWidth:sender.value];
}

//设置线的颜色
- (IBAction)setColor:(UIButton *)sender {
    
    [self.drawView setLineColor:sender.backgroundColor];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
