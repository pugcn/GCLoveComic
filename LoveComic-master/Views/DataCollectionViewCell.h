//
//  DataCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/7/28.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface DataCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImaeView;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property(nonatomic,weak) DataModel *model;

@end
