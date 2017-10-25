//
//  SortListCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/16.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,copy) NSString *sortKey;
@property (nonatomic,copy) NSString *sortValue;

@end
