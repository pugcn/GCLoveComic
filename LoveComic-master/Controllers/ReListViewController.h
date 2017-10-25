//
//  ReListViewController.h
//  LoveComic-master
//
//  Created by puguichuan on 17/8/15.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshDelegate <NSObject>
-(void)berefresh;

@end

@interface ReListViewController : UIViewController
@property (weak, nonatomic) id<RefreshDelegate> delegate;
@end
