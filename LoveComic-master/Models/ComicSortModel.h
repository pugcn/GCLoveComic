//
//  ComicSortModel.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/16.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>

@class ComicSortListModel;

@interface ComicSortModel : NSObject

@property (nonatomic,strong) NSArray<ComicSortListModel *>* comic_sort;

@end


@interface ComicSortListModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *sort_group;

@property (nonatomic,strong) NSDictionary *data;

@end
