//
//  SortUtility.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/16.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#ifndef SortUtility_h
#define SortUtility_h

#import "ComicSortModel.h"
#import "SortDetailmodel.h"
#import "DownLoadManager.h"
#import "WRNavigationBar.h"
#import "SortListCollectionViewCell.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "ComicDetailViewController.h"
#import "SortDetailCollectionViewCell.h"
#import <UIImageView+WebCache.h>


#define LoveColorFromHexadecimalRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

/*====书库地址======*/
#define ComicSortURL @"https://api.yyhao.com/app_api/v2/getconfig/"
/******sort图地址*****/
#define SortImgURL  @"http://image.samanlehua.com/file/kanmanhua_images/sort/%@.png"

/*==cover图地址========*/
#define CoverURL  @"http://image.samanlehua.com/mh/%ld.jpg"

/*======详情========*/
//sort=类别value  search_key=关键字 page=刷新页面（1-total_page）
//orderby=click(人气)/score(评分)/date(更新)
#define SortDetailURL  @"https://api.yyhao.com/app_api/v2/getsortlist/?comic_sort=%@&page=%ld&orderby=%@&search_key="

#define SearchDetailURL  @"https://api.yyhao.com/app_api/v2/getsortlist/?comic_sort=&page=%ld&orderby=%@&search_key=%@"

/*==================热门搜索地址===============*/
#define HotSearchURL  @"https://api.yyhao.com/app_api/v2/gettopsearch/"

#endif /* SortUtility_h */
