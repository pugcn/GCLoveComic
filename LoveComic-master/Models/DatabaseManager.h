//
//  DatabaseManager.h
//  LoveComic-master
//
//  Created by puguichuan on 17/7/27.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleCase.h"
#import "ComicDescModel.h"

@interface DatabaseManager : NSObject
SingleCaseH(DatabaseManager) // 单例声明

-(BOOL)saveComic:(ComicDescModel *)comic;

-(NSMutableArray *)allComic;

-(ComicDescModel *)selectedModel:(ComicDescModel *)comic;

-(BOOL)deleateAllComic:(ComicDescModel *)comic;
@end
