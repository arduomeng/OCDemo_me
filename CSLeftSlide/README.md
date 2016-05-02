# CSLeftSlide
A simple gesture of sideslip demo, suitable for beginners to learn

# 参考
分装了两个控制器CSLeftSlideControllerOne和CSLeftSlideControllerTwo分别实现两种侧滑效果。

调用控制器的- (id)initWithLeftViewController:(UIViewController *)leftVC MainViewController:(UIViewController *)mainVC方法

传入左侧控制器和主界面控制器，即可为它们添加侧滑效果。

CSLeftSlideControllerOne *LeftSlideController = [[CSLeftSlideControllerOne alloc] initWithLeftViewController:leftVC MainViewController:mainNav];

或者

CSLeftSlideControllerTwo *LeftSlideController = [[CSLeftSlideControllerTwo alloc] initWithLeftViewController:leftVC MainViewController:mainNav];

[self addChildViewController:LeftSlideController];

[self.view addSubview:LeftSlideController.view];

效果图：
![image](https://github.com/YourAcountName/ProjectName/blob/master/GIFName.gif ) 

# 具体使用参考Demo
