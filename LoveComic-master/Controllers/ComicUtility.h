//
//  ComicUtility.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/4.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#ifndef ComicUtility_h
#define ComicUtility_h

#import "DownLoadManager.h"
#import "ComicDescModel.h"
#import "RelevantModel.h"
#import "AllDelegate.h"
#import "WRNavigationBar.h"
#import "UIImage+ImageEffects.h"
#import <UIImageView+WebCache.h>
#import <UIImage+MultiFormat.h>
#import <Masonry.h>
#import "ComicDescCollectionViewCell.h"
#import "ChapterListCollectionViewCell.h"
#import "RelevantCollectionViewCell.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 240
#define NAV_HEIGHT 64
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define LoveColorFromHexadecimalRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/*====漫画简介地址======*/
#define ComicDescURL @"https://api.yyhao.com/app_api/v2/getcomicinfo/?comic_id=%ld"
/*====相关推荐地址======*/
#define RelevantURL @"https://api.yyhao.com/app_api/v2/getrelationcomic/?comic_id=%ld"
/******cover图地址*****/
#define CoverURL  @"http://image.samanlehua.com/mh/%ld.jpg"
/******章节图地址*****/
#define ChapterURL_1  @"http://mhpic.%@%@-mht.middle"
#define ChapterURL_2  @"http://mhpic.taomanhua.com%@"

#endif /* ComicUtility_h */
