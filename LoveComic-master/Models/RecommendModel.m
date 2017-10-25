//
//  RecommendModel.m
//  LoveComic-master
//
//  Created by puguichuan on 17/7/26.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "RecommendModel.h"


@implementation RecommendModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data":[DataModel class],
             @"slide":[SlideModel class]};
}

@end

@implementation DataModel


@end

@implementation SlideModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{

    return @{@"imageUrl":@"image"};
}


@end
