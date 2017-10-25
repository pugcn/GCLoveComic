//
//  ChapterListCollectionViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/7.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ChapterListCollectionViewCell.h"

@implementation ChapterListCollectionViewCell

-(void)setModel:(ChapterListModel *)model{
    _model=model;
    
    NSString *chName =_model.chapter_name;
    NSString *temp2 =nil;
    NSString *temp3 =nil;
    NSString *temp4 =nil;
    if ([chName length]>4) {
        
        temp2= [chName substringWithRange:NSMakeRange(2, 1)];
        temp3= [chName substringWithRange:NSMakeRange(3, 1)];
        temp4= [chName substringWithRange:NSMakeRange(4, 1)];
    }
    if (([temp2 isEqualToString:@"话"] || [temp2 isEqualToString:@"卷"] || [temp2 isEqualToString:@"回"]) && [chName length]>7) {
        self.chNameLabel.text=[_model.chapter_name substringToIndex:6];
    }
    else if (([temp3 isEqualToString:@"话"] || [temp3 isEqualToString:@"卷"] || [temp3 isEqualToString:@"回"]) && [chName length]>7) {
        self.chNameLabel.text=[_model.chapter_name substringToIndex:7];
    }
    else if  (([temp4 isEqualToString:@"话"] || [temp4 isEqualToString:@"卷"] || [temp4 isEqualToString:@"回"]) && [chName length]>7) {
        self.chNameLabel.text=[_model.chapter_name substringToIndex:7];
    }
    else if([chName length]>7)
    {
        self.chNameLabel.text=[_model.chapter_name substringToIndex:5];
    }
    else{
        self.chNameLabel.text=_model.chapter_name;
    }
    
}

@end
