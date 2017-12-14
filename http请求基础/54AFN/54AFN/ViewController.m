


/*
 
 2大管理对象
 
 //对NSURLConnection的封装
 AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
 
 //对NSURLSession的封装
 AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
 
 */

#import "ViewController.h"
#import "AFNetworking.h"
@interface ViewController () <UIActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    
}

- (void) getJson
{
    
    //1.创建一个请求操作管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //声明服务器返回的数据类型，默认是JSON
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //2.请求参数(AFN将传入的参数自动进行转码，拼接)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"username"] = @"123";
    params[@"pwd"] = @"123";
    
    //3.发送一个GET请求
    NSString *url = @"http://localhost:8080/MJServer/login";
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        NSLog(@"请求失败");
         NSLog(@"%@", error);
    }];
    
    
}

- (void) postJSON
{
    //1.创建一个请求操作管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //声明服务器返回的数据类型，默认是JSON
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //2.请求参数(AFN将传入的参数自动进行转码，拼接)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"username"] = @"123";
    params[@"pwd"] = @"123";
    
    //3.发送一个GET请求
    NSString *url = @"http://localhost:8080/MJServer/login";
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        NSLog(@"请求失败");
        NSLog(@"%@", error);
    }];
}

- (void) getXML
{
    //1.创建一个请求操作管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //声明服务器返回的数据类型，XML
    mgr.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    //2.请求参数(AFN将传入的参数自动进行转码，拼接)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"username"] = @"123";
    params[@"pwd"] = @"123";
    
    //3.发送一个GET请求
    NSString *url = @"http://localhost:8080/MJServer/login";
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSXMLParser *responseObject) {
        //成功
        NSLog(@"%@", responseObject);
        
        //返回的是NSXMLParser对象,得到responseObject后设置代理开始解析
        responseObject .delegate = self;
        [responseObject parse];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        NSLog(@"请求失败");
        NSLog(@"%@", error);
    }];
}

- (void) getData
{
    //1.创建一个请求操作管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //声明服务器返回的数据类型，Data
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.请求参数(AFN将传入的参数自动进行转码，拼接)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"username"] = @"123";
    params[@"pwd"] = @"123";
    
    //3.发送一个GET请求
    NSString *url = @"http://localhost:8080/MJServer/login";
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功
        NSLog(@"%@", responseObject);
        
        //返回的是Data对象，可以进行需要的操作，例如JSON解析，XML解析，文件下载
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        NSLog(@"请求失败");
        NSLog(@"%@", error);
    }];
}


//文件上传
- (void) upload1
{
    //1.创建一个管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //2.封装参数(字典只能放非文件参数)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"username"] = @"123";
    params[@"age"] = @20;
    
    //3.发送一个请求
    NSString *url = @"http://localhost:8080/MJServer/upload";
    
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //这个block事发送请求之前会调用的block
        //需要在这个block中添加文件参数到formData中
        
        
        
        
        /*
         fileData: 需要上传的文件的数据
         name:  服务器那边接受文件用的参数
         fileName : 告诉服务器上传的文件的文件名
         mimeType: 所上传的文件的类型
         */
        //通过NSData的方式上传
//        UIImage *img = [UIImage imageNamed:@"minion_01.png"];
//        NSData *fileData = UIImagePNGRepresentation(img);
//        [formData appendPartWithFileData:fileData name:@"file" fileName:@"haha.png" mimeType:@"image/png"];
        
        //通过url的方式上传
        //获取本地文件的url路径然后上传
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"itcast" withExtension:@"txt"];
        [formData appendPartWithFileURL:fileUrl name:@"file" fileName:@"xxx.txt" mimeType:@"text/plain" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传成功");
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败");
    }];
}

@end
