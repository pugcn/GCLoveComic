//
//  ProcessButton.h
//  ProcessButton
//
//  Created by yuanzhou on 2017/9/5.
//  Copyright © 2017年 yuanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProcessButton : UIButton

//**轨道颜色**//
@property (nonatomic ,strong) UIColor   *trackColor;

//**进度条颜色**//
@property (nonatomic ,strong) UIColor   *processColor;

//**背景填充颜色**//
@property (nonatomic ,strong) UIColor   *fillColor;

//**进度线条宽度**//
@property (nonatomic ,assign) CGFloat   lineWidth;

//**进度条时间**//
@property (nonatomic ,assign) CGFloat   animationtime;

@property (nonatomic ,copy) void(^Block)(void);

-(instancetype)initWithFrame:(CGRect)frame;

- (void)startAnimationDuration:(CGFloat)duration;

@end
