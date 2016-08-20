# progressView
###这是一个加载进度的控件。可以对进度在圆环上加上点进行分段。
* 这是最近项目中用到的，顺便分享给大家。如果你想自己写一个加载的，完全可以参考此demo



```
- (LDPlanProgressView *)progressView
{
    if (!_progressView) {
         UIColor *backColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _progressView = [[LDPlanProgressView alloc] initWithLineColor:[UIColor whiteColor] loopColor:backColor];
        _progressView.percent = 0;
    }
    return _progressView;
}

在viewDidLoad中

NSArray *timeArray = @[@10,@10,@10];//时间数组，则圆环上显示3点分。从顶部开始加载
[self.view addSubview:self.progressView];
// 设置分段数据
self.progressView.timeArray = timeArray;

```
![image](https://github.com/linxyang/progressView/blob/master/1.gif)
