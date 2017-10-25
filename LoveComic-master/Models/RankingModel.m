//
//  RankingModel.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/12.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "RankingModel.h"

@implementation RankingModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rankinglist":[RankingListModel class]};
}

@end


@implementation RankingListModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data":[RankingDataModel class]};
}

@end

@implementation RankingDataModel


@end
