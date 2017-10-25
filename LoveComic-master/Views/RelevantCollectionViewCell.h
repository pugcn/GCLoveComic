//
//  RelevantCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/23.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicUtility.h"

@interface RelevantCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSArray *array;

@property (weak, nonatomic) id<AllDelegate> delegate;
@end
