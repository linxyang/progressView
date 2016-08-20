//
//  LDPlanProgressView.h
//  进度视图
//
//  Created by fuchun on 16/8/18.
//  Copyright © 2016年 nzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDPlanProgressView : UIView

/**
 *  构造方法
 *
 *  @param lineColor 线的颜色
 *  @param loopColor 圆环颜色
 *  @param timeArray 每步的时长数组
 */
-(instancetype)initWithLineColor:(UIColor*)lineColor
                       loopColor:(UIColor*)loopColor;


/**
 *  时间数组
 */
@property (nonatomic, strong) NSArray<NSNumber *> *timeArray;
/**
 *  进度
 */
@property (nonatomic,assign) CGFloat percent;

/**
 *  线颜色，默认灰
 */
@property (nonatomic,strong) UIColor* lineColor;
/**
 *  圆环颜色，默认白
 */
@property (nonatomic,strong) UIColor *loopColor;

/**
 *  标题:一直显示:当前位置
 */
@property (nonatomic,copy) NSString* title;
/**
 *  标题颜色:0x999999
 */
@property (nonatomic,strong) UIColor *titleColor;

/**
 *  当前部位名
 */
@property (nonatomic, copy) NSString *partName;
/**
 *  部位字体颜色
 */
@property (nonatomic,strong)  UIColor* partNameColor;


@end
