//
//  SortDetailmodel.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/18.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "SortDetailmodel.h"

@implementation SortDetailmodel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data":[SortDataModel class],@"page":[PageModel class]};
}

@end

@implementation PageModel


@end

@implementation SortDataModel


@end

