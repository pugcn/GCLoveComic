//
//  ProcessButton.m
//  ProcessButton
//
//  Created by yuanzhou on 2017/9/5.
//  Copyright © 2017年 yuanzhou. All rights reserved.
//



#define degreesToRadians(x) ((x) * M_PI / 180.0)

#import "ProcessButton.h"

@interface ProcessButton()<CAAnimationDelegate>

//**轨道**//
@property (nonatomic ,strong) CAShapeLayer  *trackLayer;

//**进度**//
@property (nonatomic ,strong) CAShapeLayer  *processLayer;

//**贝塞尔曲线**//
@property (nonatomic ,strong) UIBezierPath  *bezierPath;


@end

@implementation ProcessButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.trackLayer];
    }
    return self;
}


- (UIBezierPath *)bezierPath
{
    if (!_bezierPath) {
        
        CGFloat width = CGRectGetWidth(self.frame)/2.0f;
        CGFloat height = CGRectGetHeight(self.frame)/2.0f;
        CGPoint centerPoint = CGPointMake(width, height);
        float radius = CGRectGetWidth(self.frame)/2;
        
        _bezierPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                     radius:radius
                                                 startAngle:degreesToRadians(-90)
                                                   endAngle:degreesToRadians(270)
                                                  clockwise:YES];
    }
    return _bezierPath;
}
-(CAShapeLayer *)trackLayer{
    
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.frame = self.bounds;
        _trackLayer.fillColor = self.fillColor.CGColor ? self.fillColor.CGColor : [[UIColor blackColor] colorWithAlphaComponent:0.05].CGColor ;
        _trackLayer.lineWidth = self.lineWidth ? self.lineWidth : 2.f;
        _trackLayer.strokeColor = self.trackColor.CGColor ? self.trackColor.CGColor : [UIColor redColor].CGColor ;
        _trackLayer.strokeStart = 0.f;
        _trackLayer.strokeEnd = 1.f;
        _trackLayer.path = self.bezierPath.CGPath;
    }
    return _trackLayer;
}
-(CAShapeLayer *)processLayer{
    
    if (!_processLayer) {
        _processLayer = [CAShapeLayer layer];
        _processLayer.frame = self.bounds;
        _processLayer.fillColor = [UIColor clearColor].CGColor;
        _processLayer.lineWidth = self.lineWidth ? self.lineWidth : 2.f;
        _processLayer.lineCap = kCALineCapRound;
        _processLayer.strokeColor = self.processColor.CGColor ? self.processColor.CGColor  : [UIColor lightGrayColor].CGColor;
        _processLayer.strokeStart = 0.f;
        
        //给layer添加动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.animationtime;
        pathAnimation.fromValue = @(0.0);
        pathAnimation.toValue = @(1.0);
        pathAnimation.removedOnCompletion = YES;
        pathAnimation.delegate = self;
        [_processLayer addAnimation:pathAnimation forKey:nil];
        _processLayer.path = _bezierPath.CGPath;
    }
    
    return _processLayer;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        if (self.Block) {
            self.Block();
        }
    }
}
- (void)startAnimationDuration:(CGFloat)duration{
    self.animationtime = duration;
    [self.layer addSublayer:self.processLayer];
}


@end
