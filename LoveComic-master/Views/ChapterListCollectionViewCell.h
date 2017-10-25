//
//  ChapterListCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/7.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicUtility.h"

@interface ChapterListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *chNameLabel;

@property (nonatomic,strong) ChapterListModel *model;


@end
