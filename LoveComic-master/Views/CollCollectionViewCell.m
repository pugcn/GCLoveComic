//
//  CollCollectionViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/9/11.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "CollCollectionViewCell.h"
#import "RecommendUtility.h"

@implementation CollCollectionViewCell
-(void)setModel:(ComicDescModel *)model{
    _model=model;
    CALayer *cellImageLayer = self.coverImaeView.layer;
    [cellImageLayer setCornerRadius:5];
    [cellImageLayer setMasksToBounds:YES];
    NSString *coverUrl=[NSString stringWithFormat:CoverURL,_model.comic_id];
    self.updateLabel.textColor=[UIColor whiteColor];
    self.updateLabel.font = [UIFont boldSystemFontOfSize:9];
    self.updateLabel.backgroundColor=[UIColor clearColor];
    self.updateLabel.highlighted=YES;
    self.nameLabel.textColor=LoveColorFromHexadecimalRGB(0x1874CD);
    [self.coverImaeView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
    self.nameLabel.text=_model.comic_name;
    self.updateLabel.text=_model.last_chapter_name;
    
}
@end
