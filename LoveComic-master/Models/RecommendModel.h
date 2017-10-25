//
//  RecommendModel.h
//  LoveComic-master
//
//  Created by puguichuan on 17/7/26.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@class DataModel,SlideModel;


/**
 主目录
 */
@interface RecommendModel : NSObject<YYModel>

@property (nonatomic,copy) NSString * tab_title;

@property (nonatomic,strong) NSArray<DataModel *>* data;

@property (nonatomic,strong) NSArray<SlideModel *>* slide;


@end


/**
 推荐漫画
 */
@interface DataModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger comic_id;

@property (nonatomic,copy) NSString * comic_name;

@property (nonatomic,copy) NSString * last_chapter_name;

@end


/**
 轮播图
 */
@interface SlideModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger comic_id;

@property (nonatomic,copy) NSString * imageUrl;

@property (nonatomic,copy) NSString * slide_desc;

@end
