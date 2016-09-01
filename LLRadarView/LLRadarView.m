//
//  LLRadarView.m
//  LLRadarView
//
//  Created by 雷亮 on 16/8/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLRadarView.h"

#define HEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]

#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : (alphaValue)]

#define kDefaultColorValue 0x36ae29

@interface LLRadarView ()

@property (nonatomic, strong) CALayer *radarLayer;
@property (nonatomic, strong) dispatch_group_t opacity_group;
@property (nonatomic, assign) BOOL stopOpacity;
@property (nonatomic, assign) BOOL isExecute;

@end

@implementation LLRadarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildingParams];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildingParams];
    }
    return self;
}

- (void)buildingParams {
    self.backgroundColor = [UIColor clearColor];
    self.alphaColor = HEXCOLOR(kDefaultColorValue);
    self.circleCount = 3;
    self.circleColor = HEXCOLOR(kDefaultColorValue);
    self.circleWidth = 2.f;
    self.showCrossline = NO;
    self.crosslineColor = HEXCOLOR(kDefaultColorValue);
    self.crosslineWidth = 2.f;
    self.duration = 1.5f;
    self.needOpacityAnimation = NO;
    self.isExecute = NO;
    self.stopOpacity = YES;
    self.pointColor = HEXCOLOR(kDefaultColorValue);
    self.pointRadius = 3.f;
}

- (void)buildingLayer {
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height) / 2;
    if (self.circleCount > 0) {
        CGFloat minRadius = radius / self.circleCount;
        for (NSInteger i = 0; i < self.circleCount; i ++) {
            CAShapeLayer *circlelayer = [CAShapeLayer layer];
            circlelayer.fillColor = [UIColor clearColor].CGColor;
            circlelayer.strokeColor = self.circleColor.CGColor;
            circlelayer.lineWidth = self.circleWidth;
            circlelayer.lineCap = kCALineCapButt;
            circlelayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:minRadius * (i + 1) startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
            [self.layer addSublayer:circlelayer];
        }
    }
    
    self.radarLayer = [CALayer layer];
    // frame
    if (self.frame.size.width > radius * 2) {
        CGFloat left = (self.frame.size.width - radius * 2) / 2;
        self.radarLayer.frame = CGRectMake(left, 0, radius * 2, radius * 2);
    } else if (self.frame.size.height > radius * 2) {
        CGFloat top = (self.frame.size.height - radius * 2) / 2;
        self.radarLayer.frame = CGRectMake(0, top, radius * 2, radius * 2);
    } else {
        self.radarLayer.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    }
    // 添加渐变色
    CGFloat averageAngle = M_PI * 2 / 360;
    for (int i = 0; i < 270; i ++) {
        CGFloat startAngle = averageAngle * i;
        CGFloat endAngle = startAngle + averageAngle;
        CGFloat alpha = i / 270.f;
        [self appendAlphaLayer:self.radarLayer startAngle:startAngle endAngle:endAngle color:self.alphaColor alpha:alpha radius:radius];
    }
    [self.layer addSublayer:self.radarLayer];
    
    if (self.showCrossline) {
        CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        
        CAShapeLayer *crosslineLayer = [CAShapeLayer layer];
        crosslineLayer.fillColor = [UIColor clearColor].CGColor;
        crosslineLayer.strokeColor = self.crosslineColor.CGColor;
        crosslineLayer.lineWidth = self.crosslineWidth;
        crosslineLayer.lineCap = kCALineCapButt;
        
        CGMutablePathRef crosslinePath = CGPathCreateMutable();
        // 横线
        CGPathMoveToPoint(crosslinePath, &CGAffineTransformIdentity, center.x - radius, center.y);
        CGPathAddLineToPoint(crosslinePath, &CGAffineTransformIdentity, center.x + radius, center.y);
        // 竖线
        CGPathMoveToPoint(crosslinePath, &CGAffineTransformIdentity, center.x, center.y - radius);
        CGPathAddLineToPoint(crosslinePath, &CGAffineTransformIdentity, center.x, center.y + radius);
        
        crosslineLayer.path = crosslinePath;
        [self.layer addSublayer:crosslineLayer];
        
        CGPathRelease(crosslinePath);
    }
}

- (void)appendAlphaLayer:(CALayer *)layer startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius {
    CGFloat r, g, b;
    [color getRed:&r green:&g blue:&b alpha:nil];
    
    CAShapeLayer *sublayer = [CAShapeLayer layer];
    sublayer.strokeColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha].CGColor;
    sublayer.lineWidth = radius;
    sublayer.lineCap = kCALineCapButt;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, &CGAffineTransformIdentity, radius, radius, radius / 2, startAngle, endAngle, NO);
    sublayer.path = path;
    [layer addSublayer:sublayer];
    
    CGPathRelease(path);
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @0;
    animation.toValue = @(2 * M_PI);
    animation.duration = self.duration;
    animation.repeatCount = MAXFLOAT;
    [self.radarLayer addAnimation:animation forKey:@"rotate"];
    
    if (self.needOpacityAnimation) {
        if (!self.stopOpacity) {
            return;
        }
        if (self.isExecute) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.stopOpacity = NO;
                [self addOpacityAnimation];
            });
        } else {
            self.stopOpacity = NO;
            [self addOpacityAnimation];
        }
    }
}

- (void)stopAnimation {
    [self.radarLayer removeAllAnimations];
    self.stopOpacity = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self buildingLayer];
}

#pragma mark -
#pragma mark - OpacityAnimation
- (void)addOpacityAnimation {
    self.isExecute = YES;
    self.opacity_group = nil;
    self.opacity_group = dispatch_group_create();

    int count = [self randomNumberFrom:1 to:10];
    
    for (int i = 0; i < count; i ++) {
        dispatch_group_enter(self.opacity_group);
        CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        CGFloat radius = MIN(self.frame.size.width, self.frame.size.height) / 2;
        CGFloat centerX = [self randomNumberFrom:center.x - radius to:center.x + radius];
        CGFloat centerY = [self randomNumberFrom:center.y - radius to:center.y + radius];
        [self addOpacityPointWithCenter:CGPointMake(centerX, centerY) radius:self.pointRadius];
    }
    
    dispatch_group_notify(self.opacity_group, dispatch_get_main_queue(), ^{
        self.isExecute = NO;
        if (!self.stopOpacity) {
            [self addOpacityAnimation];
        } else {
            self.opacity_group = nil;
        }
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    dispatch_group_leave(self.opacity_group);
}

- (void)addOpacityPointWithCenter:(CGPoint)center radius:(CGFloat)radius {
    // 闪烁点
    CAShapeLayer *pointLayer = [CAShapeLayer layer];
    pointLayer.fillColor = self.pointColor.CGColor;
    pointLayer.strokeColor = self.pointColor.CGColor;
    pointLayer.lineWidth = self.pointRadius;
    pointLayer.lineCap = kCALineCapButt;
    pointLayer.opacity = 0.f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, &CGAffineTransformIdentity, center.x, center.y, radius, 0, 2 * M_PI, YES);
    pointLayer.path = path;
    [self.layer addSublayer:pointLayer];
    
    CGPathRelease(path);
    
    // 闪烁动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0.f;
    animation.toValue = @1.f;
    animation.autoreverses = YES;
    animation.duration = 1.f;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeRemoved;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.delegate = self;

    [pointLayer addAnimation:animation forKey:nil];
}

- (int)randomNumberFrom:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
