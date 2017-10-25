//
//  CollectionViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/9/11.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "CollectionViewController.h"
#import "ComicDescModel.h"
#import "DatabaseManager.h"
#import "XFAlertView.h"
#import "CollCollectionViewCell.h"
#import "ComicDetailViewController.h"
#import "BookshelfViewController.h"

@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BooKDelegate,XFAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) ComicDescModel *cdModel;

@property(nonatomic,assign)CGFloat historyY;
@end

@implementation CollectionViewController

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
    
   
    
    
}
-(void)garAction:(UIButton *)sender{
    
}

-(void)delAction:(UIButton *)sender{
    
    XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                       Msg:@"大人，你真的不要我们了吗？"                                        CancelBtnTitle:@"取消"
                                                OKBtnTitle:@"确定"
                                                       Img:[UIImage imageNamed:@"collcover"]];
    alert.delegate=self;
    [alert show];
    
}
- (void)alertView:(XFAlertView *)alertView didClickTitle:(NSString *)title{
    if ([title isEqualToString:@"确定"]) {
        for (ComicDescModel *model in self.dataArray) {
            NSString *isread=[[DatabaseManager sharedDatabaseManager]selectedModel:model].read_chapter_name;
            if (isread==nil) {
                [[DatabaseManager sharedDatabaseManager]deleateAllComic:model];
            }
            else{
                model.isColl=0;
                model.read_chapter_name=isread;
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
            if (ccmodel.isColl==1) {
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
    [self.parentViewController setValue:self forKey:@"delegate"];
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
    
    //漫画内容加载
    CollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicdata" forIndexPath:indexPath];
    ComicDescModel *model=self.dataArray[indexPath.row];
    [cell.deleteBtn setHidden:YES];
    cell.coverImaeView.layer.masksToBounds=YES;
    cell.coverImaeView.alpha=1;
    cell.model=model;
    return cell;
}

- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
     NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
    CollCollectionViewCell *cell = (CollCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
       
        
       
        if (indexPath == nil) {
            
        }else{
            
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
    NSString *isread=[[DatabaseManager sharedDatabaseManager]selectedModel:self.cdModel].read_chapter_name;
    if (isread==nil) {
        [[DatabaseManager sharedDatabaseManager]deleateAllComic:self.cdModel];
    }
    else{
        self.cdModel.isColl=0;
        self.cdModel.read_chapter_name=isread;
        [[DatabaseManager sharedDatabaseManager]saveComic:self.cdModel];
    }
    [self.dataArray removeObject:self.cdModel];
    [self.collectionView reloadData];
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
    if ([segue.identifier isEqualToString:@"cotodesc"]) {
        ComicDetailViewController *destVC=segue.destinationViewController;
        NSIndexPath *indexPath=[self.collectionView indexPathForCell:sender];
        destVC.hidesBottomBarWhenPushed = YES;
        self.parentViewController.title=@"";
        ComicDescModel *model=self.dataArray[indexPath.row];
        destVC.comic_id=model.comic_id;
    }
    
}


@end
