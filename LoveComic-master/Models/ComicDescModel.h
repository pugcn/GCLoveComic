//
//  ComicDescModel.h
//  LoveComic-master
//
//  Created by puguichuan on 17/7/31.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>

@class ChapterModel,ChapterListModel,ChapterSourceModel;
@interface ComicDescModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger comic_id;

@property(nonatomic,copy) NSString *comic_name;

@property (nonatomic,strong) NSDictionary * comic_type;

@property (nonatomic,assign) NSInteger comic_status;

@property (nonatomic,assign) NSInteger update_time;

@property(nonatomic,copy) NSString *comic_author;

@property(nonatomic,copy) NSString *last_chapter_id;

@property(nonatomic,copy) NSString *read_chapter_name;

@property(nonatomic,assign) NSInteger isColl;

@property(nonatomic,copy) NSString *last_chapter_name;

@property(nonatomic,copy) NSString *comic_desc;

@property (nonatomic,strong) NSArray<ChapterModel *>* comic_chapter;

@end


@interface ChapterModel : NSObject<YYModel>

@property(nonatomic,copy) NSString *chapter_type;

@property (nonatomic,strong) NSArray<ChapterListModel *>* chapter_list;

@end


@interface ChapterListModel : NSObject<YYModel>

@property(nonatomic,copy) NSString *chapter_name;

@property(nonatomic,copy) NSString *chapter_id;

@property (nonatomic,assign) NSInteger create_date;

@property (nonatomic,strong) NSArray<ChapterSourceModel *>* chapter_source;

@end


@interface ChapterSourceModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger site_id;

@property (nonatomic,assign) NSInteger start_num;

@property (nonatomic,assign) NSInteger end_num;

@property(nonatomic,copy) NSString *rule;

@property(nonatomic,copy) NSString *source_url;

@property(nonatomic,copy) NSString *chapter_domain;

@end
