//
//  ComicSortModel.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/16.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ComicSortModel.h"

@implementation ComicSortModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"comic_sort":[ComicSortListModel class]};
}

@end

@implementation ComicSortListModel


@end
