//
//  LLPulseAnimation.h
//  LLRadarView
//
//  Created by 雷亮 on 16/9/2.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLPulseAnimation : NSObject

/**
 * @brief 给视图添加脉冲动画
 * @param targetView : 目标视图
 * @param pulseColor : 脉冲层颜色
 * @param pulseDiameter : 脉冲层的最大直径
 * @param duration : 单次脉冲的时间
 */
+ (CALayer *)addPulseAnimationAtTargetView:(UIView *)targetView
                                pulseColor:(UIColor *)pulseColor
                             pulseDiameter:(CGFloat)pulseDiameter
                                  duration:(CGFloat)duration;

/**
 * @brief 判断视图是否已经添加过脉冲动画
 * @param targetView : 目标视图
 */
+ (BOOL)pulseAnimationAtTargetView:(UIView *)targetView;

/**
 * @brief 移除视图的脉冲动画
 * @param targetView : 目标视图
 */
+ (void)removePulseAnimationWithTargetView:(UIView *)targetView;

@end
