//
//  UpdateModel.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/12.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>
@class UpDateListModel,InFoModel;

@interface UpdateModel : NSObject<YYModel>

@property (nonatomic,strong) NSArray<UpDateListModel *>* update;

@property (nonatomic,copy) NSString * tab_title;

@end

/**
 更新目录
 */
@interface UpDateListModel : NSObject<YYModel>

@property (nonatomic,copy) NSString * comicUpdateDate;

@property (nonatomic,strong) NSArray<InFoModel *>* info;

@end


/**
 更新详情
 */
@interface InFoModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger comic_id;

@property (nonatomic,copy) NSString * comic_name;

@property (nonatomic,copy) NSString * comic_chapter_name;

@property (nonatomic,copy) NSString * update_time;

@property (nonatomic,strong) NSArray<NSString *>* comic_type;

@end
