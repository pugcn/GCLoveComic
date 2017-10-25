//
//  UpdateListViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/29.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "UpdateListViewController.h"
#import "RecommendUtility.h"
#import "UpDateCollectionViewCell.h"
@interface UpdateListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *theUpDateArray;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property(nonatomic,assign)CGFloat historyY;
@end

@implementation UpdateListViewController

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
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self requestData];
}

-(void)requestData{
    UpDateListModel *ulModel=self.theUpDateArray.firstObject;
   
    NSArray *arr=ulModel.info;
    for (InFoModel *Imodel in arr) {
        [self.dataArray addObject:Imodel];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.dataArray removeAllObjects];
    [self requestData];
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




#pragma mark UICollectionViewDataSource &&UICollectionViewDelegate

/**
 显示多少节
 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  1;
}

/**
 每节多少个cell
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

/**
 显示cell内容
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //漫画内容加载
    UpDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicdata" forIndexPath:indexPath];
    InFoModel *model=self.dataArray[indexPath.row];
    cell.model=model;
    return cell;
}




/**
 设置cell大小
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellx = (self.collectionView.frame.size.width - 5 * 10)/3.0f;
    CGFloat scale=800.0f/600.0f;
    
    CGFloat celly=scale*cellx+20.0f;
    
    return CGSizeMake(cellx,celly);
    
    
}
/**
 设置cell之间的间隔距离
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"uptodesc"]) {
        ComicDetailViewController *destVC=segue.destinationViewController;
        NSIndexPath *indexPath=[self.collectionView indexPathForCell:sender];
        destVC.hidesBottomBarWhenPushed = YES;
        self.parentViewController.parentViewController.title=@"";
        InFoModel *model=self.dataArray[indexPath.row];
        destVC.comic_id=model.comic_id;
    }
    
}



@end
