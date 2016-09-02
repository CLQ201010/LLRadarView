//
//  LLPulseAnimation.m
//  LLRadarView
//
//  Created by 雷亮 on 16/9/2.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLPulseAnimation.h"

static NSString *const kPulseAnimationKey = @"kPulseAnimationKey";

@implementation LLPulseAnimation

+ (CALayer *)addPulseAnimationAtTargetView:(UIView *)targetView
                                pulseColor:(UIColor *)pulseColor
                             pulseDiameter:(CGFloat)pulseDiameter
                                  duration:(CGFloat)duration {
    CALayer *pulseLayer = [CALayer layer];
    pulseLayer.bounds = CGRectMake(0, 0, pulseDiameter, pulseDiameter);
    pulseLayer.cornerRadius = pulseDiameter / 2;
    pulseLayer.position = targetView.center;
    pulseLayer.backgroundColor = pulseColor.CGColor;
    [targetView.superview.layer insertSublayer:pulseLayer below:targetView.layer];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = NO;
    
    CAMediaTimingFunction *mediaTimingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animationGroup.timingFunction = mediaTimingFunction;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.7;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.4;
    opacityAnimation.toValue = @0.0;
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [pulseLayer addAnimation:animationGroup forKey:kPulseAnimationKey];
    return pulseLayer;
}

+ (BOOL)pulseAnimationAtTargetView:(UIView *)targetView {
    NSArray *layers = [NSArray arrayWithArray:targetView.superview.layer.sublayers];
    for (CALayer *layer in layers) {
        if ([layer.animationKeys containsObject:kPulseAnimationKey]) {
            return YES;
        }
    }
    return NO;
}

+ (void)removePulseAnimationWithTargetView:(UIView *)targetView {
    NSArray *layers = [NSArray arrayWithArray:targetView.superview.layer.sublayers];
    for (CALayer *layer in layers) {
        if ([layer.animationKeys containsObject:kPulseAnimationKey]) {
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
}

@end
