//
//  DatabaseManager.m
//  LoveComic-master
//
//  Created by puguichuan on 17/7/27.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDatabase.h>
#import <FMDatabaseAdditions.h>


#define kDBName @"comic.db"
#define kComicTableName @"comicTable"

@interface DatabaseManager()

@property (strong,nonatomic) FMDatabase *database;

@end

@implementation DatabaseManager
//单例实现
SingleCaseM(DatabaseManager)


//获取沙盒文件目录
-(NSString *)DBPath{
    NSArray * dirList=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[dirList firstObject];
    NSLog(@"%@",path);
    return [path stringByAppendingPathComponent:kDBName];
}

/**
 建表
 */
-(instancetype)init{
    self=[super init];
    if (self) {
        NSString *path = self.DBPath;
        NSLog(@"%@",path);
        self.database = [FMDatabase databaseWithPath:path];
        if ([self.database open]) {
            //创建漫画表
            NSString *createSql=[NSString stringWithFormat:@"create table if not exists %@ (comic_id integer UNIQUE, comic_name text,last_chapter_name text,read_chapter_name text,isColl integer)",kComicTableName];
            if (![self.database executeUpdate:createSql]) {
                NSLog(@"建表/打开表： %@  失败",kComicTableName);
                return nil;
            }
        }
    }
    return self;
}

-(BOOL)saveComic:(ComicDescModel *)comic{
    if (comic==nil) {
        return NO;
    }
    //判断数据库是否有值
    NSString *sqlStr=[NSString stringWithFormat:@"select count(*) from %@ where comic_id=?",kComicTableName];
    NSInteger count=[self.database intForQuery:sqlStr,@(comic.comic_id)];
    BOOL success;
    if (count==0) {
        sqlStr=[NSString stringWithFormat:@"insert into %@ (comic_id,comic_name,last_chapter_name,read_chapter_name,isColl) values(?,?,?,?,?)",kComicTableName];
        success=[self.database executeUpdate:sqlStr,@(comic.comic_id),comic.comic_name,comic.last_chapter_name,comic.read_chapter_name,@(comic.isColl)];
        if (!success) {
            NSLog(@"保存漫画错误：%@",comic.comic_name);
        }
    }
    else{
        sqlStr=[NSString stringWithFormat:@"update %@ set comic_name=?,last_chapter_name=?,read_chapter_name=?,isColl=? where comic_id=?",kComicTableName];
        success=[self.database executeUpdate:sqlStr,comic.comic_name,comic.last_chapter_name,comic.read_chapter_name,@(comic.isColl),@(comic.comic_id)];
        if (!success) {
            NSLog(@"更新漫画错误：%@",comic.comic_name);
        }
        
    }
    return success;
}

//查询漫画
-(NSMutableArray *)allComic{
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@",kComicTableName];
    FMResultSet *resuletSet=[self.database executeQuery:sqlStr];
    
    NSMutableArray *comicArray=[NSMutableArray new];
    while ([resuletSet next]) {
        ComicDescModel *comic=[ComicDescModel new];
        comic.comic_id=([resuletSet intForColumn:@"comic_id"]);
        
        comic.comic_name=([resuletSet stringForColumn:@"comic_name"]);
        comic.last_chapter_name=([resuletSet stringForColumn:@"last_chapter_name"]);
        comic.read_chapter_name=([resuletSet stringForColumn:@"read_chapter_name"]);
        comic.isColl=([resuletSet intForColumn:@"isColl"]);
        [comicArray addObject:comic];
    }
    return comicArray;
}


/**
 查询漫画

 */
-(ComicDescModel *)selectedModel:(ComicDescModel *)comic{
     NSString *sqlStr=[NSString stringWithFormat:@"select * from %@ where comic_id=?",kComicTableName];
    FMResultSet *resuletSet=[self.database executeQuery:sqlStr,@(comic.comic_id)];
    ComicDescModel *model=[ComicDescModel new];
     while ([resuletSet next]) {
         model.comic_id=([resuletSet intForColumn:@"comic_id"]);
         model.comic_name=([resuletSet stringForColumn:@"comic_name"]);
         model.last_chapter_name=([resuletSet stringForColumn:@"last_chapter_name"]);
         model.read_chapter_name=([resuletSet stringForColumn:@"read_chapter_name"]);
         model.isColl=([resuletSet intForColumn:@"isColl"]);
     }
    
    return model;
}

//删除对应漫画
-(BOOL)deleateAllComic:(ComicDescModel *)comic{
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where comic_id=?",kComicTableName];
    BOOL success=[self.database executeUpdate:sqlStr,@(comic.comic_id)];
    return success;
}



@end
