//
//  CollCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/9/11.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ComicDescModel.h"

@interface CollCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *coverImaeView;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) ComicDescModel *model;
@end
