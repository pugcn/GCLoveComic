//
//  Cell2CollectionViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/9/15.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "Cell2CollectionViewCell.h"
#import "RecommendUtility.h"
@implementation Cell2CollectionViewCell


-(void)setModel:(ComicDescModel *)model{
    _model=model;
    CALayer *cellImageLayer = self.coverImageView.layer;
    [cellImageLayer setCornerRadius:5];
    [cellImageLayer setMasksToBounds:YES];
    NSString *coverUrl=[NSString stringWithFormat:CoverURL,_model.comic_id];
    self.nameLabel.textColor=LoveColorFromHexadecimalRGB(0x1874CD);
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
    self.nameLabel.text=_model.comic_name;
    self.chapterLabel.text=[NSString stringWithFormat:@"%@ %@",@"上次阅读:",_model.read_chapter_name];
    
}
@end
