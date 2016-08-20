//
//  LDPlanProgressView.m
//  进度视图
//
//  Created by fuchun on 16/8/18.
//  Copyright © 2016年 nzq. All rights reserved.
//

#import "LDPlanProgressView.h"
#define angle2Arc(angle) (angle * M_PI /180)
//设置文字缩放比例
#define FontScale MIN(self.bounds.size.height, self.bounds.size.width)/100.f
@interface LDPlanProgressView ()
{
    CGFloat radius;
}

/** 弧度 */
@property (nonatomic,assign)CGFloat angle;
/** 圆心 */
@property (nonatomic,assign)CGPoint circleCenter;
/** 总时间 */
@property (nonatomic, assign) CGFloat totalTime;

@end

@implementation LDPlanProgressView


-(instancetype)init{
    if (self = [super init]) {
        [self defaultColor];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultColor];
    }
    return self;
}

-(instancetype)initWithLineColor:(UIColor*)lineColor
                       loopColor:(UIColor*)loopColor{
    if (self = [super init]) {
        self.lineColor = lineColor;
        self.loopColor = loopColor;
        //百分比，超过100，按照100算
        self.percent = 0;
        //属性可选的，可以不设置，设置透明就是圆环
        self.backgroundColor = [UIColor clearColor];
        //设置标题
        self.title = @"当前位置";
    }
    return self;
}

// 设置数据
- (void)setTimeArray:(NSArray<NSNumber *> *)timeArray
{
    _timeArray = timeArray;
    [self setNeedsDisplay];
}

-(void)defaultColor{
    _lineColor = [UIColor whiteColor];//线颜色
    _loopColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];//圆环背景色
    _titleColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];//文字颜色
    _partNameColor = [UIColor whiteColor];//部位文字颜色
}

// 总时长
- (CGFloat)totalTime
{
    if (!_totalTime) {
        _totalTime = 0;
        for (NSNumber *time in self.timeArray) {
            _totalTime = _totalTime + time.floatValue;
        }
    }
    return _totalTime;
}

- (void)drawRect:(CGRect)rect {

    _circleCenter = CGPointMake(rect.size.width*0.5 , rect.size.height*0.5 );
    
    radius = MIN(rect.size.height, rect.size.width) * 0.5;
    
    //画内圆
    UIBezierPath* arc2 = [UIBezierPath bezierPathWithArcCenter:_circleCenter
                                                        radius:radius*0.9
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];//顺时针
    [arc2 setLineWidth:radius*0.05];
    [self.loopColor set];

     [arc2 stroke];
  
    //画弧线
    UIBezierPath* path = [UIBezierPath
                          bezierPathWithArcCenter:_circleCenter
                          radius:radius*0.9
                          startAngle:-M_PI_2// 从-90度开始
                          endAngle:angle2Arc(self.angle)-M_PI_2
                          clockwise:YES];
    [self.lineColor set];
    
    [path setLineCapStyle:kCGLineCapRound];
    path.lineWidth = radius* 0.05;
    [path stroke];
    
    
    // 画步骤上的点
    static CGFloat rateValue = 0;
    for (int i = 0; i < self.timeArray.count; i++) {
        
        CGFloat time = self.timeArray[i].floatValue;//这个步骤要花的时间
        CGFloat rate = time /self.totalTime ;
        rateValue = rateValue+rate;
        
        //确定原点的位置
        CGPoint StartCircleCenter  = CGPointMake(_circleCenter.x + radius*0.9 * sinf(M_PI-rateValue*2*M_PI),
                                                  
                                                  _circleCenter.y + radius*0.9 * cosf(M_PI-rateValue*2*M_PI));
  
        //画个点
        UIBezierPath* startCircle = [UIBezierPath
                                      bezierPathWithArcCenter:StartCircleCenter
                                      radius:radius*0.05*0.6//圆的半径大小
                                      startAngle:0
                                      endAngle:2*M_PI//圆
                                      clockwise:YES];
        
        [startCircle fill];
    }
    
    [self drawText];
   
}



/**
 *  绘制文字
 */

-(void)drawText{
    
    //绘制标题
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:self.title];
    NSRange titleRange = NSMakeRange(0, title.string.length);
    [title addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:12]
                  range:titleRange];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:self.titleColor
                  range:titleRange];
    
    CGRect titleRect = [title boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
    
    CGFloat titleX = _circleCenter.x  - titleRect.size.width * 0.5;
    CGFloat titleY = _circleCenter.y -  titleRect.size.height;
    
    [title drawAtPoint:CGPointMake(titleX, titleY)];
    
    // 绘制部位
    NSMutableAttributedString* partName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.partName]];
    
    NSRange partNameRange = NSMakeRange(0, partName.string.length);
    
    [partName addAttribute:NSFontAttributeName
                       value:[UIFont boldSystemFontOfSize:16]
                       range:partNameRange];
    
    [partName addAttribute:NSForegroundColorAttributeName
                       value:self.partNameColor
                       range:partNameRange];
    
    CGRect partRect = [partName boundingRectWithSize:self.bounds.size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
    
    CGFloat partX = _circleCenter.x - partRect.size.width * 0.5;
    CGFloat partY = _circleCenter.y + 5;//partRect.size.height;//中心下移5
    
    [partName drawAtPoint:CGPointMake(partX, partY)];
}

-(void)setPercent:(CGFloat)precent{
    if (precent>100) {
        precent = 100;
    }
    _percent = precent;
    _angle = _percent /100 * 360;
    [self setNeedsDisplay];
}

#pragma mark - 设置默认颜色

-(UIColor *)titleColor{
    if (_titleColor == nil) {
        _titleColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];//
    }
    return _titleColor;
}

-(UIColor*)partNameColor{
    if (_partNameColor == nil) {
        _partNameColor = [UIColor whiteColor];
    }
    return _partNameColor;
}

#pragma mark - 懒加载title
-(NSString *)title{
    if (_title == nil) {
        _title = @"当前位置";
    }
    return _title;
}


-(void)dealloc{
    NSLog(@"dealloc");
}



@end
