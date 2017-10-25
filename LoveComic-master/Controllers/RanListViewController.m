//
//  RanListViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/30.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "RanListViewController.h"
#import "RankingTableViewCell.h"
#import "RecommendUtility.h"
#import <Masonry/Masonry.h>

@interface RanListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *theRankingArray;

@property(nonatomic,assign)CGFloat historyY;
@end

@implementation RanListViewController

#pragma mark 懒加载

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    [self requestData];
}

-(void)requestData{
    RankingListModel *model=self.theRankingArray.firstObject;
    NSArray *arr=model.data;
    for (RankingDataModel *rdModel in arr) {
        [self.dataArray addObject:rdModel];
    }
    
}

#pragma mark ScrolDelegate

//设置滑动的判定范围
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.historyY+20<targetContentOffset->y)
    {
        [self setTabBarHidden:YES];
    }
    else if(self.historyY-20>targetContentOffset->y)
    {
        
        [self setTabBarHidden:NO];
    }
    self.historyY=targetContentOffset->y;
}
//隐藏显示tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    CGRect  tabRect=self.tabBarController.tabBar.frame;
    if ([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
        tabRect.origin.y=[[UIScreen mainScreen]bounds].size.height+self.tabBarController.tabBar.frame.size.height;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        tabRect.origin.y=[[UIScreen mainScreen] bounds].size.height-self.tabBarController.tabBar.frame.size.height;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.tabBarController.tabBar.frame=tabRect;
    }completion:^(BOOL finished) {
        
    }];
    
}



#pragma mark UItableViewDelegate&&UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RankingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"rankingcell" forIndexPath:indexPath];
    RankingDataModel *model=self.dataArray[indexPath.row];
     cell.rangkLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.rangkLabel.textColor=[UIColor whiteColor];
    cell.rangkLabel.backgroundColor=[UIColor clearColor];
    cell.model=model;
    if (indexPath.row==0) {
        cell.rankImageView.image=[UIImage imageNamed:@"rank1"];
    }
    else if  (indexPath.row==1) {
        cell.rankImageView.image=[UIImage imageNamed:@"rank2"];
    }
    else if (indexPath.row==2) {
        cell.rankImageView.image=[UIImage imageNamed:@"rank3"];
    }
    else{
        cell.rankImageView.image=nil;
        cell.rangkLabel.text=@"";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"rantodesc"]) {
        ComicDetailViewController *destVC=segue.destinationViewController;
        NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
        destVC.hidesBottomBarWhenPushed = YES;
        self.parentViewController.parentViewController.title=@"";
        RankingDataModel *model=self.dataArray[indexPath.row];
        destVC.comic_id=model.comic_id;
    }
    
}

@end
