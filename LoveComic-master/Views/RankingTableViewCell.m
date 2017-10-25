//
//  RankingTableViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/30.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "RankingTableViewCell.h"
#import "RecommendUtility.h"
#import <Masonry/Masonry.h>

@implementation RankingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(RankingDataModel *)model{
    _model=model;
    if (_model!=nil) {
        CALayer *cellImageLayer = self.coverImageView.layer;
        [cellImageLayer setCornerRadius:5];
        [cellImageLayer setMasksToBounds:YES];
        NSMutableString *nameStr=[[NSMutableString alloc]initWithString:_model.comic_name];
        CALayer *cellRankLayer = self.rangkLabel.layer;
        [cellRankLayer setCornerRadius:20];
        [cellRankLayer setMasksToBounds:YES];
        if (nameStr.length>15) {
            //长度太长时将中间省略
            [nameStr replaceCharactersInRange:NSMakeRange(9, 5) withString:@"..."];
        }
        self.nameLabel.text=nameStr;
        self.authorLabel.text=_model.author;
        self.datelLabel.text=[NSString stringWithFormat:@"%@ %@",@"更新至：",_model.last_chapter_name];
        NSString *coverUrl=[NSString stringWithFormat:CoverURL,_model.comic_id];
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
        NSArray *arr=_model.comic_type;
        if (arr.count==1) {
            self.type1Label.text=arr[0];
            [self setLabelUI:self.type1Label];
            self.type2Label.text=@"";
            self.type3Label.text=@"";
            self.type4Label.text=@"";

        }
        if (arr.count==2) {
            self.type1Label.text=arr[0];
            [self setLabelUI:self.type1Label];
            self.type2Label.text=arr[1];
            [self setLabelUI:self.type2Label];
            self.type3Label.text=@"";
            self.type4Label.text=@"";
            
        }
        if (arr.count==3) {
            self.type1Label.text=arr[0];
            [self setLabelUI:self.type1Label];
            self.type2Label.text=arr[1];
            [self setLabelUI:self.type2Label];
            self.type3Label.text=arr[2];
            [self setLabelUI:self.type3Label];
            self.type4Label.text=@"";
        }
        if (arr.count==4) {
            self.type1Label.text=arr[0];
            [self setLabelUI:self.type1Label];
            self.type2Label.text=arr[1];
            [self setLabelUI:self.type2Label];
            self.type3Label.text=arr[2];
            [self setLabelUI:self.type3Label];
            self.type4Label.text=arr[3];
            [self setLabelUI:self.type4Label];
        }
    }
}

-(void)setLabelUI:(UILabel *)label{
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius=3;
    label.textColor=[UIColor darkGrayColor];
    label.backgroundColor=[UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
