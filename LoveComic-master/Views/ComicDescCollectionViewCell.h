//
//  ComicDescCollectionViewCell.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/4.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicUtility.h"

@interface ComicDescCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *collBtn;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) ComicDescModel *model;
@property (weak, nonatomic) IBOutlet UIButton *decsBtn;
@property(nonatomic,copy) NSString *updateName;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property(nonatomic,assign) NSInteger comic_id;

@property (weak, nonatomic) id<AllDelegate> delegate;

@end
