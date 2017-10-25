//
//  LightChangeManger.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/20.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SingleCase.h"


@interface LightChangeManger : NSObject<NSCoding>

SingleCaseH(LightChangeManger) // 单例声明

@property (nonatomic,assign) CGFloat brightness;
@end
