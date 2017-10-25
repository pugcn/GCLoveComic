//
//  ComicDetailViewController.h
//  LoveComic-master
//
//  Created by puguichuan on 17/7/31.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface ComicDetailViewController : UIViewController

@property(nonatomic,strong) SlideModel *smodel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong) DataModel *dmodel;
@property(nonatomic,assign) NSInteger comic_id;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationItem *navItem;
@end
