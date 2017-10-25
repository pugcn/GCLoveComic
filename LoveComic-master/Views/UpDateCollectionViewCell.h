//
//  UpDateCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/29.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateModel.h"

@interface UpDateCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImaeView;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property(nonatomic,strong) InFoModel *model;

@end
