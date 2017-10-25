//
//  ProcessLaunchImageView.m
//  ProcessButton
//
//  Created by yuanzhou on 2017/9/5.
//  Copyright © 2017年 yuanzhou. All rights reserved.
//

#import "ProcessLaunchImageView.h"
#import "ProcessButton.h"

@interface ProcessLaunchImageView()<CAAnimationDelegate>

@property (nonatomic ,strong) UIImageView       *bgImageView;

@property (nonatomic ,strong) ProcessButton     *processButton;

@property (nonatomic ,strong) dispatch_source_t timer;

@property (nonatomic ,copy) ResultProgressBlock block;

@end

@implementation ProcessLaunchImageView


+(instancetype)initShareView:(CGRect)bounds bgImageName:(NSString *)imageName ShowType:(TitleShowtype)showType Time:(CGFloat)time ResultBlock:(ResultProgressBlock)block{
    
    ProcessLaunchImageView *View = nil;
    if (!View) {
        View = [[ProcessLaunchImageView alloc]initWithFrame:bounds bgName:imageName ShowType:showType Time:time];
        View.block = block;
    }
    return View;
}

-(instancetype)initWithFrame:(CGRect)frame bgName:(NSString *)bgname ShowType:(TitleShowtype)showType Time:(CGFloat)time{
    if (self = [super initWithFrame:frame]) {
        
        //**创建背景ImageView**//
        [self addSubview:self.bgImageView];
        self.bgImageView.image = [UIImage imageNamed:bgname];
        
        //**创建Button**//
        [self addSubview:self.processButton];
        [self.processButton startAnimationDuration:time];
        
        //**设置ButtonTile**//
        [self setButtonTitle:showType Time:time];
    }
    return self;
}
/**
 *  设置广告图片
 **/
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        
        self.bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        
        self.bgImageView.contentMode=UIViewContentModeScaleAspectFill;
        
       self.bgImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *ImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageViewTapClick)];
        [self.bgImageView addGestureRecognizer:ImageTap];
        
    }
    return _bgImageView;
}
/**
 *  ImageView上添加一个点击事件
 **/
-(void)ImageViewTapClick{
    if (self.block) {
        self.block();
    }
}
/**
 *  创建进度Button
 **/
-(ProcessButton *)processButton{
    
    if (!_processButton) {
        _processButton = [[ProcessButton alloc]initWithFrame:CGRectMake(self.bounds.size.width- 60, 20, 30, 30)];
        _processButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_processButton addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_processButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        __weak ProcessLaunchImageView *WeakSelf  = self;
        _processButton.Block = ^{
            [WeakSelf dismiss];
        };
    }
    
    return _processButton;
}

/**
 *  Button点击事件
 **/
-(void)ButtonClick{
    [self dismiss];
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
}
/**
 *  设置Button显示Title
 */
-(void)setButtonTitle:(TitleShowtype)type Time:(CGFloat)time{
    if (type == ButtonTitleJumpShowType) {
        //表示用户设置的是跳过
        [self.processButton setTitle:@"跳过" forState:UIControlStateNormal];
        
    }else if (type == ButtonTitleTimeShowType){
        //表示用户设置的是显示倒计时
        __block NSInteger timeOut = time;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //每秒执行一次
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            //倒计时结束，关闭
            if (timeOut <= 0) {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismiss];
                });
            } else {
                int allTime = (int)time + 1;
                int seconds = timeOut % allTime;
                NSString *timeStr = [NSString stringWithFormat:@"%ds", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.processButton setTitle:timeStr forState:UIControlStateNormal];
                });
                timeOut--;
            }
        });
        dispatch_resume(_timer);
    }
}
/**
 *  移除View动画
 **/
-(void)dismiss{
    
    self.processButton.hidden = YES;
    self.transform = CGAffineTransformMakeScale(1, 1);
    self.bgImageView.alpha = 1;
    
    [UIView animateWithDuration:0.7 animations:^{
        self.bgImageView.alpha = 0.05;
        self.bgImageView.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
