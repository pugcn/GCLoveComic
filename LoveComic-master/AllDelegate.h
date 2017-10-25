//
//  AllDelegate.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/26.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AllDelegate <NSObject>
//选择相关推荐代理方法
- (void)choseRelevant:(UIButton *)sender;

//选择类型代理方法
- (void)choseSort:(UIButton *)sender;

- (void)readClick:(UIButton *)sender;

@end
