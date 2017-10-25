//
//  ProcessLaunchImageView.h
//  ProcessButton
//
//  Created by yuanzhou on 2017/9/5.
//  Copyright © 2017年 yuanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ResultProgressBlock)(void);


typedef NS_ENUM(NSInteger,TitleShowtype){
    ButtonTitleTimeShowType = 0,    //显示倒计时
    ButtonTitleJumpShowType = 1,    //显示跳过
};

@interface ProcessLaunchImageView : UIView

/**
 *
 *  @param bounds           视图bounds
 *  @param imageName        背景视图广告图片
 *  @param showType         ButtonTitleTimeShowType 倒计时 ButtonTitleJumpShowType 跳过
 *  @param time             设置倒计时时间
 *  @param block            广告ImageView点击Block 在里面执行你的操作
 *
 */
+(instancetype)initShareView:(CGRect)bounds
                 bgImageName:(NSString *)imageName
                    ShowType:(TitleShowtype)showType
                        Time:(CGFloat)time
                 ResultBlock:(ResultProgressBlock)block;

@end
