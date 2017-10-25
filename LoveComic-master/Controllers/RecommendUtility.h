//
//  RecommendUtility.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/4.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#ifndef RecommendUtility_h
#define RecommendUtility_h


#import "RecommendModel.h"
#import "UpdateModel.h"
#import "RankingModel.h"
#import "DownLoadManager.h"
#import "XXPageTabView.h"
#import "WRNavigationBar.h"
#import "ComicDetailViewController.h"
#import <UIImageView+WebCache.h>


#define LoveColorFromHexadecimalRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/*==================推荐列表接口地址===============*/
#define RecommendListURL @"https://api.yyhao.com/app_api/v2/getrecommend/"
/*====排行地址======*/
#define RankingURL @"https://api.yyhao.com/app_api/v2/rankinglist/"
/*====更新地址======*/
#define UpdateURL @"https://api.yyhao.com/app_api/v2/updatelist/"

/*==================cover图地址===============*/
#define CoverURL  @"http://image.samanlehua.com/mh/%ld.jpg"
/*==================热门搜索地址===============*/
#define HotSearchURL  @"https://api.yyhao.com/app_api/v2/gettopsearch/"
#endif /* RecommendUtility_h */
