

/*
 
 AFN不能监听文件的上传进度
 */


#import "ViewController.h"
#import "AFNetworking.h"
@interface ViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)btnUploadClick;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"图库", nil];
    
    //将sheet现实到window，这样当控制器的self的view从窗口中移除，也不会错误
    
    [sheet showInView:self.view.window];
}

#pragma mark - actionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    
    switch (buttonIndex) {
        case 1://图库
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                return;
            }
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 0://相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                return;
            }
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        default:
            break;
    }
    //显示控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - imagePickerController

//选中一张图片后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //获得图片
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    //显示图片
    self.imgView.image = img;
    
}


//上传
- (IBAction)btnUploadClick {
    
    if (self.imgView.image == nil) {
        return;
    }
    
    //1.创建一个管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //2.封装参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = @"lcs";
    params[@"age"] = @22;
    
    
    //3.发送一个请求
    NSString *url = @"http://localhost:8080/MJServer/upload";
    
    NSData *data = UIImageJPEGRepresentation(self.imgView.image, 1.0);
    
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"select.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}
@end
