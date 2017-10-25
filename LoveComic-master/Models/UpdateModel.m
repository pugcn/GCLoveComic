//
//  UpdateModel.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/12.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "UpdateModel.h"

@implementation UpdateModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"update":[UpDateListModel class]};
}

@end

@implementation UpDateListModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"info":[InFoModel class]};
}

@end

@implementation InFoModel



@end
