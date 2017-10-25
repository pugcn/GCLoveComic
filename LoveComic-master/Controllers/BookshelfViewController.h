//
//  BookshelfViewController.h
//  LoveComic-master
//
//  Created by puguichuan on 17/9/8.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BooKDelegate <NSObject>
- (void)delAction:(UIButton *)sender;

- (void)garAction:(UIButton *)sender;
@end


@interface BookshelfViewController : UIViewController
@property (weak, nonatomic) id<BooKDelegate > delegate;
@property (weak, nonatomic) id<BooKDelegate > hdelegate;

@property (nonatomic,assign) BOOL iscoll;

@end
