//
//  SortDetailmodel.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/18.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>
@class PageModel,SortDataModel;

@interface SortDetailmodel : NSObject<YYModel>

@property (nonatomic,strong) PageModel *page;

@property (nonatomic,strong) NSArray<SortDataModel *>* data;

@end


@interface PageModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger current_page;

@property (nonatomic,assign) NSInteger total_page;

@property (nonatomic,copy) NSString *orderby;

@property (nonatomic,copy) NSString *comic_sort;

@end


@interface SortDataModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger comic_id;

@property (nonatomic,copy) NSString * comic_name;

@property (nonatomic,copy) NSString * last_chapter_name;

@end


