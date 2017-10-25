//
//  RecommendViewController.h
//  LoveComic-master
//
//  Created by puguichuan on 17/7/24.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义
@protocol SendDelegate <NSObject>
-(void)sendRecomend:(NSMutableArray *)reArr;

@end


@interface RecommendViewController : UIViewController
@property (weak, nonatomic) id<SendDelegate> delegate;
@end

