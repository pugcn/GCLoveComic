//
//  ComicDescModel.m
//  LoveComic-master
//
//  Created by puguichuan on 17/7/31.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ComicDescModel.h"

@implementation ComicDescModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"comic_chapter":[ChapterModel class]};
}

@end


@implementation ChapterModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"chapter_list":[ChapterListModel class]};
}

@end


@implementation ChapterListModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"chapter_source":[ChapterSourceModel class]};
}

@end


@implementation ChapterSourceModel


@end
