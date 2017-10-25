//
//  ReListViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/15.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ReListViewController.h"
#import "RecommendUtility.h"
#import "DIYMJRefreshHeader.h"
#import "RecommendViewController.h"
#import "LunboCollectionViewCell.h"
#import "DataCollectionViewCell.h"
#import <SDCycleScrollView.h>
@interface ReListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,SendDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *theRecommendArray;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) NSMutableArray * headerArray;

@property(nonatomic,assign)CGFloat historyY;

@end

@implementation ReListViewController
#pragma mark 懒加载

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)headerArray{
    if (!_headerArray) {
        _headerArray=[[NSMutableArray alloc]init];
    }
    return _headerArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    
    self.collectionView.mj_header=[DIYMJRefreshHeader headerWithRefreshingBlock:^{
        [self beginRefresh];
    }];
    [self reuestData];
}
-(void)reuestData{
    RecommendModel *Rmodel =self.theRecommendArray.firstObject;
    for (DataModel *Dmodel in Rmodel.data) {
        [self .dataArray addObject:Dmodel];
    }
    for (SlideModel *SModel in Rmodel.slide) {
        [self.headerArray addObject:SModel];
    }
}

-(void)beginRefresh{
   [self.parentViewController setValue:self forKey:@"delegate"];
    if(_delegate){
    if ([_delegate respondsToSelector:@selector(berefresh)]) {
        [_delegate berefresh];
    }
    }
}
-(void)sendRecomend:(NSMutableArray *)reArr{
    if (reArr==nil) {
         [self.collectionView.mj_header endRefreshing];
    }
    if (reArr!=nil) {
    [self.dataArray removeAllObjects];
    
    [self.headerArray removeAllObjects];
    self.theRecommendArray = [NSMutableArray new];
    self.theRecommendArray=reArr;
    [self reuestData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    });
    }
}
#pragma mark Delegate

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
    
    return  2;
}

/**
 每节多少个cell
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section==0 ) {
        return 1;
    }
    return self.dataArray.count;
}

/**
 显示cell内容
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        //轮播图加载
        LunboCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"lunbo" forIndexPath:indexPath];
        [self reloadLunbo:cell];
        cell.backgroundColor=LoveColorFromHexadecimalRGB(0x1874CD);
        
        return cell;
    }
    //漫画内容加载
    DataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicdata" forIndexPath:indexPath];
    DataModel *dmodel=self.dataArray[indexPath.row];
    cell.model=dmodel;
    return cell;
}




/**
 设置cell大小
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        CGFloat scale=375.0f/750.0f;
        
        CGFloat celly=kScreenWidth*scale;
        if (self.headerArray.count==0) {
            return CGSizeMake(kScreenWidth,0);
        }
        return CGSizeMake(kScreenWidth,celly);
    }
    CGFloat cellx = (self.collectionView.frame.size.width - 5 * 10)/3.0f;
    CGFloat scale=800.0f/600.0f;
    
    CGFloat celly=scale*cellx+20.0f;
    
    return CGSizeMake(cellx,celly);
    
    
}
/**
 设置cell之间的间隔距离
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    if (section==0) {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)reloadLunbo:(UICollectionViewCell *)cell{
    UIScrollView *lunBoscrollView = [[UIScrollView alloc] initWithFrame:cell.frame];
    lunBoscrollView.contentSize = CGSizeMake(cell.frame.size.width, cell.frame.size.height);
    [cell addSubview:lunBoscrollView];
    NSMutableArray *lunboUrls=[NSMutableArray new];
    NSMutableArray *titles=[NSMutableArray new];
    for (SlideModel *Smodel in self.headerArray) {
        [lunboUrls addObject:Smodel.imageUrl];
        [titles addObject:Smodel.slide_desc];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:cell.frame delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.autoScrollTimeInterval =3;
    cycleScrollView.pageControlDotSize=CGSizeMake(7,7);
    cycleScrollView.currentPageDotColor = LoveColorFromHexadecimalRGB(0xFF7256); // 自定义分页控件小圆标颜色
    cycleScrollView.imageURLStringsGroup = lunboUrls;
    [lunBoscrollView addSubview:cycleScrollView];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    NSMutableArray<SlideModel *> *comics=[NSMutableArray<SlideModel *> new];
    for (SlideModel *Smodel in self.headerArray) {
        [comics addObject:Smodel];
    }
    self.parentViewController.title=@"";
    ComicDetailViewController *cdVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comicdetail"];
    cdVC.comic_id=comics[(long)index].comic_id;
    cdVC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:cdVC animated:YES];
    NSLog(@"---点击了第%ld张图片", (long)index);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"comtodesc"]) {
        ComicDetailViewController *destVC=segue.destinationViewController;
        NSIndexPath *indexPath=[self.collectionView indexPathForCell:sender];
        self.parentViewController.title=@"";
        destVC.hidesBottomBarWhenPushed = YES;
        DataModel *dmodel=self.dataArray[indexPath.row];
        destVC.comic_id=dmodel.comic_id;
    }
   
}


@end
