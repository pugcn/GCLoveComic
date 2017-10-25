//
//  HistoryViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/9/14.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "HistoryViewController.h"
#import "ComicDescModel.h"
#import "DatabaseManager.h"
#import "ComicDetailViewController.h"
#import "CollCollectionViewCell.h"
#import "BookshelfViewController.h"
#import "XFAlertView.h"
#import "Cell2CollectionViewCell.h"
@interface HistoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BooKDelegate,XFAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) ComicDescModel *cdModel;

@property(nonatomic,assign)CGFloat historyY;

@end

@implementation HistoryViewController
{
    BOOL isgar;
}

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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.collectionView addGestureRecognizer:longPress];
    isgar=YES;
    
    
}
-(void)garAction:(UIButton *)sender{
    if (isgar==YES) {
        isgar=NO;
         [self.collectionView reloadData];
        
    }
    else{
         isgar=YES;
        [self.collectionView reloadData];
       
    }
   
}

-(void)delAction:(UIButton *)sender{
    
    XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                       Msg:@"清空历史，不留小秘密！"                                        CancelBtnTitle:@"取消"
                                                OKBtnTitle:@"确定"
                                                       Img:[UIImage imageNamed:@"collcover"]];
    alert.delegate=self;
    [alert show];
    
}
- (void)alertView:(XFAlertView *)alertView didClickTitle:(NSString *)title{
    if ([title isEqualToString:@"确定"]) {
        for (ComicDescModel *model in self.dataArray) {
            NSInteger iscoll=[[DatabaseManager sharedDatabaseManager]selectedModel:model].isColl;
            if (iscoll==0) {
                [[DatabaseManager sharedDatabaseManager]deleateAllComic:model];
            }
            else{
                model.isColl=1;
                model.read_chapter_name=nil;
                [[DatabaseManager sharedDatabaseManager]saveComic:model];
            }
        }
        [self.dataArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
    }
    
    
}
-(void)requestData{
    __weak typeof(self) weakSelf = self;
    [weakSelf.dataArray removeAllObjects];
    NSMutableArray *arr=[NSMutableArray new];
    [arr addObject: [[DatabaseManager sharedDatabaseManager] allComic]];
    NSArray *darr=arr.firstObject;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        for (ComicDescModel *ccmodel in darr) {
            if (ccmodel.read_chapter_name!=nil) {
                [weakSelf.dataArray addObject:ccmodel];
            }
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.collectionView reloadData];
        });
        
    });
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self.parentViewController setValue:self forKey:@"hdelegate"];
    [self requestData];
    [super viewWillAppear:animated];
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
    if (isgar==YES) {
        //漫画内容加载
        CollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicdata" forIndexPath:indexPath];
        ComicDescModel *model=self.dataArray[indexPath.row];
        cell.model=model;
        [cell.deleteBtn setHidden:YES];
        cell.coverImaeView.layer.masksToBounds=YES;
        cell.coverImaeView.alpha=1;
        cell.model=model;
        return cell;
    }
    else{
        Cell2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
        ComicDescModel *model=self.dataArray[indexPath.row];
        cell.model=model;
        
        return cell;
    }
}

- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        if (indexPath == nil) {
            
        }else{
            CollCollectionViewCell *cell = (CollCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell.deleteBtn setHidden:NO];
            cell.coverImaeView.layer.masksToBounds=YES;
            cell.coverImaeView.alpha=0.1;
            self.cdModel=self.dataArray[indexPath.row];
            [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

-(void)deleteAction:(id)sender{
    NSInteger iscoll=[[DatabaseManager sharedDatabaseManager]selectedModel:self.cdModel].isColl;
    if (iscoll==0) {
        [[DatabaseManager sharedDatabaseManager]deleateAllComic:self.cdModel];
    }
    else{
        self.cdModel.isColl=1;
        self.cdModel.read_chapter_name=nil;
        [[DatabaseManager sharedDatabaseManager]saveComic:self.cdModel];
    }
    [self.dataArray removeObject:self.cdModel];
    [self.collectionView reloadData];
}



/**
 设置cell大小
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isgar==YES) {
        CGFloat cellx = (self.collectionView.frame.size.width - 5 * 10)/3.0f;
        CGFloat scale=800.0f/600.0f;
        
        CGFloat celly=scale*cellx+20.0f;
        
        return CGSizeMake(cellx,celly);
    }
    else{
        CGFloat cellx = self.collectionView.frame.size.width;
        
        CGFloat celly=128.0f;
        
        return CGSizeMake(cellx,celly);
    }
    
    
    
}
/**
 设置cell之间的间隔距离
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (isgar==YES) {
         return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    else{
        return UIEdgeInsetsMake(1, 0, 1, 0);
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"hitodesc"]) {
        ComicDetailViewController *destVC=segue.destinationViewController;
        NSIndexPath *indexPath=[self.collectionView indexPathForCell:sender];
        destVC.hidesBottomBarWhenPushed = YES;
        self.parentViewController.title=@"";
        ComicDescModel *model=self.dataArray[indexPath.row];
        destVC.comic_id=model.comic_id;
    }
    
}


@end
