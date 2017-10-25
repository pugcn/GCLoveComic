//
//  SortDetailCollectionViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/18.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "SortDetailCollectionViewCell.h"

#import "SortUtility.h"
@implementation SortDetailCollectionViewCell

-(void)setModel:(SortDataModel *)model{
    _model=model;
    CALayer *cellImageLayer = self.coverImaeView.layer;
    [cellImageLayer setCornerRadius:5];
    [cellImageLayer setMasksToBounds:YES];
    NSString *coverUrl=[NSString stringWithFormat:CoverURL,model.comic_id];
    self.updateLabel.textColor=[UIColor whiteColor];
    self.updateLabel.backgroundColor=[UIColor clearColor];
    self.updateLabel.highlighted=YES;
    [self.coverImaeView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
    self.nameLabel.text=model.comic_name;
    self.nameLabel.textColor=LoveColorFromHexadecimalRGB(0x1874CD);
    self.updateLabel.text=model.last_chapter_name;
    
}


@end
