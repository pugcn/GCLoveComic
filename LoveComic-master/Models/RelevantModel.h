//
//  RelevantModel.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/23.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>
@interface RelevantModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger cartoon_id;

@property (nonatomic,copy) NSString *cartoon_name;
@end
