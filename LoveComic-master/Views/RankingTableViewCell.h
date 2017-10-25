//
//  RankingTableViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/30.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"

@interface RankingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelLabel;
@property (weak, nonatomic) IBOutlet UILabel *rangkLabel;

@property (weak, nonatomic) IBOutlet UILabel *type1Label;
@property (weak, nonatomic) IBOutlet UILabel *type2Label;
@property (weak, nonatomic) IBOutlet UILabel *type3Label;
@property (weak, nonatomic) IBOutlet UILabel *type4Label;

@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property(nonatomic,strong) RankingDataModel *model;

@end
