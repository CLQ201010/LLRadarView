//
//  LLRadarView.h
//  LLRadarView
//
//  Created by 雷亮 on 16/8/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLRadarView : UIView

// 雷达蒙层颜色
@property (nonatomic, strong) UIColor *alphaColor;

// 圆环个数
@property (nonatomic, assign) NSInteger circleCount;

// 圆环颜色
@property (nonatomic, strong) UIColor *circleColor;

// 圆环宽度
@property (nonatomic, assign) CGFloat circleWidth;

// 是否显示中间的十字
@property (nonatomic, assign) BOOL showCrossline;

// 十字颜色
@property (nonatomic, strong) UIColor *crosslineColor;

// 十字的宽度
@property (nonatomic, assign) CGFloat crosslineWidth;

// 雷达蒙层每转一圈的时间
@property (nonatomic, assign) NSTimeInterval duration;

// 是否需要闪烁动画
@property (nonatomic, assign) BOOL needOpacityAnimation;

// 闪烁点的颜色
@property (nonatomic, strong) UIColor *pointColor;

// 闪烁点的半径
@property (nonatomic, assign) CGFloat pointRadius;

// 开始动画
- (void)startAnimation;

// 停止动画
- (void)stopAnimation;

@end
