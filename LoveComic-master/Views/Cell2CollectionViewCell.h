//
//  Cell2CollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/9/15.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ComicDescModel.h"
@interface Cell2CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (nonatomic,strong) ComicDescModel *model;

@end
