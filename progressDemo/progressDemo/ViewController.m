//
//  ViewController.m
//  progressDemo
//
//  Created by fuchun on 16/8/18.
//  Copyright © 2016年 nzq. All rights reserved.
//

#import "ViewController.h"
#import "LDPlanProgressView.h"

@interface ViewController ()
/**
 *  通过代码创建的进度视图
 */
@property (nonatomic,strong)LDPlanProgressView *progressView;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer1;
@end

@implementation ViewController

- (LDPlanProgressView *)progressView
{
    if (!_progressView) {
         UIColor *backColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _progressView = [[LDPlanProgressView alloc] initWithLineColor:[UIColor whiteColor] loopColor:backColor];
        _progressView.percent = 0;
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    NSArray *timeArray = @[@10,@10,@10];//时间数组
    [self.view addSubview:self.progressView];
    // 设置分段数据
    self.progressView.timeArray = timeArray;
    //设置frame
    self.progressView.frame = CGRectMake(50, 50, 120, 120);

    // 不同的点给部分赋值就行
    self.progressView.partName = @"下巴";
    
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer1 forMode:NSRunLoopCommonModes];
    

}

// 模拟定时器在走，加载进度
- (void)timeChange
{
    self.progressView.percent +=3;
    if (self.progressView.percent > 20) {
        self.progressView.partName = @"左脸";
    }
    if (self.progressView.percent > 100) {
        self.progressView.percent = 100;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
