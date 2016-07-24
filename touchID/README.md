# Touch ID 简易开发教程


## 基础知识
#### 支持系统和机型

iOS系统的指纹识别功能最低支持的机型为`iPhone 5s`，最低支持系统为`iOS 8`，虽然安装`iOS 7系统的5s`机型可以使用系统提供的指纹解锁功能，但由于`API`并未开放，所以理论上第三方软件不可使用。

#### 依赖框架

```objc
LocalAuthentication.framework
#import <LocalAuthentication/LocalAuthentication.h>
```

#### 注意事项
做`iOS 8以下`版本适配时，务必进行`API验证`，避免调用相关API引起崩溃。

```objc
if(iOS8){xxx} // 系统版本验证

if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
```
#### 使用类
`LAContext` 指纹验证操作对象

#### 操作流程

- 判断系统版本，iOS 8及以上版本执行-(void)authenticateUser方法，
- 方法自动判断设备是否支持和开启Touch ID。

#### 代码示例

```objc
- (IBAction)showTouchIDAlert:(id)sender {
    // 1.判断是否是iOS8之后
    if (!iOS8later) {
        NSLog(@"版本不对不能使用TouchID");
        return;
    }

    // 2.调用touchID的相关方法
    [self authenticateUser];
}

// 鉴定用户
- (void)authenticateUser
{
    // 创建指纹验证对象
    LAContext *context = [[LAContext alloc] init];
    NSError *yfError = nil;

    // 验证设备是否支持touchID
    // LAPolicyDeviceOwnerAuthenticationWithBiometrics 14年时候枚举只有这一个属性
    // LAPolicyDeviceOwnerAuthentication 后来加的枚举属性
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&yfError]) {
        // 支持touchID
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"XMGlocalizedReason"
                          reply:^(BOOL success, NSError * _Nullable error) {
                              if (success) {
                                  // touchID验证成功

                                  // 继续处理相关业务(注意线程)
                              }else
                              {
                                  NSLog(@"%@",error.localizedDescription);
                                  switch (error.code) {
                                      case LAErrorSystemCancel:
                                      {
                                          NSLog(@"Authentication was cancelled by the system");
                                          //切换到其他APP，系统取消验证Touch ID
                                          break;
                                      }
                                      case LAErrorUserCancel:
                                      {
                                          NSLog(@"Authentication was cancelled by the user");
                                          //用户取消验证Touch ID
                                          break;
                                      }
                                      case LAErrorUserFallback:
                                      {
                                          NSLog(@"User selected to enter custom password");
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //用户选择输入密码，切换主线程处理
                                          }];
                                          break;
                                      }
                                      default:
                                      {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              //其他情况，切换主线程处理
                                          }];
                                          break;
                                      }
                                  }
                              }
                }];

    }else
    {
        switch (yfError.code) {
            case LAErrorTouchIDNotEnrolled:
                NSLog(@"LAErrorTouchIDNotEnrolled");
                break;


            case LAErrorPasscodeNotSet:
                NSLog(@"LAErrorPasscodeNotSet"); // 此处触发showPasscodeResetAlert方法
                break;

            default:
                NSLog(@"Touch ID is unaviliable");
                break;
        }
        NSLog(@"%@", yfError.localizedDescription);
    }
}

/*
 typedef NS_ENUM(NSInteger, LAError)
 {
 //授权失败
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,

 //用户取消Touch ID授权
 LAErrorUserCancel           = kLAErrorUserCancel,

 //用户选择输入密码
 LAErrorUserFallback         = kLAErrorUserFallback,

 //系统取消授权(例如其他APP切入)
 LAErrorSystemCancel         = kLAErrorSystemCancel,

 //系统未设置密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,

 //设备Touch ID不可用，例如未打开
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,

 //设备Touch ID不可用，用户未录入
 LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
 } NS_ENUM_AVAILABLE(10_10, 8_0);

 */
```
