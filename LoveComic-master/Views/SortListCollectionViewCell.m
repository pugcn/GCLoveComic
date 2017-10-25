//
//  SortListCollectionViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/16.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "SortListCollectionViewCell.h"
#import "SortUtility.h"

@implementation SortListCollectionViewCell

-(void)setSortKey:(NSString *)sortKey{
    _sortKey=sortKey;
    NSString *urlstring=[NSString stringWithFormat:SortImgURL,_sortKey];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlstring]];
}

-(void)setSortValue:(NSString *)sortValue{
    _sortValue=sortValue;
    self.nameLabel.text=_sortValue;
}

@end
