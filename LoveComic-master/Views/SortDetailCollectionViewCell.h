//
//  SortDetailCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/18.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortUtility.h"

@interface SortDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImaeView;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property(nonatomic,weak) SortDataModel *model;
@end
