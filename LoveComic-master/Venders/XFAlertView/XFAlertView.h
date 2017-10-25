//
//  XFAlertView.h
//  SCPay
//
//  Created by weihongfang on 2017/6/28.
//  Copyright © 2017年 weihongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CANCELCOLOR [UIColor colorWithRed:35/255.f green:135/255.f blue:255/255.f alpha:1]
#define OKCOLOR [UIColor colorWithRed:108/255.f green:217/255.f blue:105/255.f alpha:1]

@class XFAlertView;

@protocol XFAlertViewDelegate <NSObject>

- (void)alertView:(XFAlertView *)alertView didClickTitle:(NSString *)title;

@end

@interface XFAlertView : UIView

@property (nonatomic, assign)id<XFAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title Msg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile OKBtnTitle:(NSString *)okBtnTitle Img:(UIImage *)img;
- (void)show;

@end
