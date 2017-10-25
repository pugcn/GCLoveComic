//
//  RankingModel.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/12.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>
@class RankingListModel,RankingDataModel;
@interface RankingModel : NSObject<YYModel>

@property (nonatomic,copy) NSString * tab_title;

@property (nonatomic,strong) NSArray<RankingListModel *>* rankinglist;

@end


@interface RankingListModel : NSObject<YYModel>

@property (nonatomic,copy) NSString * title;

@property (nonatomic,strong) NSArray<RankingDataModel *>* data;

@end

@interface RankingDataModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger comic_id;

@property (nonatomic,copy) NSString * comic_name;

@property (nonatomic,copy) NSString * last_chapter_name;

@property (nonatomic,copy) NSString * author;

@property (nonatomic,strong) NSArray<NSString *>* comic_type;

@end
