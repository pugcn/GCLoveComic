//
//  ComicDetailViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/7/31.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ComicDetailViewController.h"
#import "ComicUtility.h"
#import "DatabaseManager.h"

@interface ComicDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AllDelegate>

@property(nonatomic,strong) NSMutableArray<ComicDescModel *> *dataArray;

@property(nonatomic,strong) NSMutableArray *chapterArray;

@property(nonatomic,strong) NSMutableArray *chapterListArray;

@property(nonatomic,strong) NSDictionary *sortDict;

@property(nonatomic,strong) NSMutableArray *releVantArr;

@property(nonatomic,strong) NSMutableArray *theReArr;
@end

@implementation ComicDetailViewController{
    BOOL isY;
    BOOL isO;
}

#pragma  mark 懒加载

-(NSMutableArray *)chapterArray{
    if (!_chapterArray) {
        _chapterArray = [[NSMutableArray alloc]init];
    }
    return _chapterArray;
}

-(NSMutableArray *)theReArr{
    if (!_theReArr) {
        _theReArr = [[NSMutableArray alloc]init];
    }
    return _theReArr;
}

-(NSMutableArray *)chapterListArray{
    if (!_chapterListArray) {
        _chapterListArray=[[NSMutableArray alloc]init];
    }
    return _chapterListArray;
}

-(NSMutableArray *)releVantArr{
    if (!_releVantArr) {
        _releVantArr=[[NSMutableArray alloc]init];
    }
    return _releVantArr;
}

-(NSMutableArray<ComicDescModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray<ComicDescModel *> new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    isO=YES;
    //隐藏collectionView滚动条
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    self.title=@"";
 
    
  
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
     self.navigationController.navigationBar.clipsToBounds = YES;
     [self requestData];
    [self wr_setNavBarBackgroundAlpha:0];
    if (isY==YES) {
        [self wr_setNavBarBackgroundAlpha:1];
    }
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
  
    
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    isO=NO;
    [super viewWillDisappear:animated];
}



/**
 网络请求数据
 */
-(void)requestData{
    __weak typeof(self) weakSelf = self;
    [weakSelf.releVantArr removeAllObjects];
    [weakSelf.dataArray removeAllObjects];
    [weakSelf.chapterArray removeAllObjects];
    [weakSelf.chapterListArray removeAllObjects];
    
    NSString *url=[NSString stringWithFormat:ComicDescURL,self.comic_id];
    [[DownLoadManager sharedDownLoadManager]GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        ComicDescModel *cModel=[ComicDescModel yy_modelWithJSON:responseObject];
        cModel.comic_id=weakSelf.comic_id;
        [weakSelf.dataArray addObject:cModel];
        weakSelf.sortDict=cModel.comic_type;
        //进入主线程刷新界面
        NSArray *chArr=cModel.comic_chapter;
        for (ChapterModel *chModel in chArr) {
            NSMutableArray *clArr=[NSMutableArray new];
            for (ChapterListModel *clModel in chModel.chapter_list) {
                [clArr addObject:clModel];
            }
            [weakSelf.chapterArray addObject:chModel];
            [weakSelf.chapterListArray addObject:clArr];
        }
        [self requestRelevant];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"出错了%@",error);
    }];
}

-(void)requestRelevant{
    __weak typeof(self) weakSelf = self;
    NSString *url=[NSString stringWithFormat:RelevantURL,self.comic_id];
    [[DownLoadManager sharedDownLoadManager]GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        NSArray *arr=responseObject;
        for (int i=0; i<arr.count; i++) {
            RelevantModel *rModel=[RelevantModel yy_modelWithJSON:arr[i]];
            [weakSelf.releVantArr addObject:rModel];
            [weakSelf.theReArr addObject:rModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"出错了%@",error);
    }];
}

/**
 向上翻页显示navgationBar
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTintColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
        [self wr_setNavBarTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        [self wr_setNavBarBarTintColor:LoveColorFromHexadecimalRGB(0x1874CD)];
        self.title = self.dataArray.firstObject.comic_name;
        isY=YES;
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        [self wr_setNavBarBarTintColor:[UIColor clearColor]];
        self.title = @"";
        isY=NO;
    }
}

#pragma mark UICollectionViewDataSource &&UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.chapterArray.count+2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section<2) {
        return 1;
    }
    return [self.chapterListArray[section-2] count];
    
}

/**
 显示cell内容
 
 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        ComicDescCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"top" forIndexPath:indexPath];
        cell.comic_id=self.comic_id;
        if (self.chapterListArray.count>0) {
            ChapterListModel *clModel=self.chapterListArray[0][0];
            cell.updateName=clModel.chapter_name;
        }
        cell.delegate=self;
        cell.model=self.dataArray.firstObject;
         return cell;
    }
    if (indexPath.section==1) {
        RelevantCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"recell" forIndexPath:indexPath];
        cell.delegate=self;
        if (isO==YES) {
           cell.array=self.releVantArr;
        }
        
        [self.releVantArr removeAllObjects];
        return cell;
    }
    ChapterListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"chapter" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor lightTextColor];
    cell.layer.cornerRadius=13.5;
    cell.layer.borderColor=[UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth=0.3;
    ChapterListModel *model=self.chapterListArray[indexPath.section-2][indexPath.row];
    cell.model=model;
    return cell;
  
}

-(void)choseSort:(UIButton *)sender{
    NSArray *sorKeyArr=self.sortDict.allKeys;
    NSString *sortKey=sorKeyArr[sender.tag];
    UIViewController *sdVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sortDetail"];
    [sdVC setValue:sortKey forKey:@"theSortKey"];
    [sdVC setValue:self.sortDict[sortKey] forKey:@"theSortValue"];
     self.title=@"";
    [self.navigationController pushViewController:sdVC animated:YES];
}

-(void)choseRelevant:(UIButton *)sender{
    NSLog(@"============%ld",sender.tag);
    ComicDetailViewController *cdVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comicdetail"];
    RelevantModel *model=self.theReArr[sender.tag];
    cdVC.comic_id=model.cartoon_id;
    self.title=@"";
    [self.navigationController pushViewController:cdVC animated:YES];
    
  
}

-(void)readClick:(UIButton *)sender{
    UIViewController *cpVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comicchapter"];
    if (self.chapterListArray.count>0) {
       NSArray *arr=self.chapterListArray[0];
    
    
    
    ComicDescModel *model=self.dataArray.firstObject;
    ComicDescModel *cdModel=[[DatabaseManager sharedDatabaseManager]selectedModel
                             :model];
    if (cdModel.isColl==1) {
        model.isColl=1;
    }
    else{
        model.isColl=0;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        ChapterListModel *clModel=self.chapterListArray[0][arr.count-1];
        if (cdModel.read_chapter_name!=nil) {
            for (ChapterModel *chModel in self.chapterArray) {
                for (ChapterListModel *chlModel in chModel.chapter_list) {
                    if ([cdModel.read_chapter_name isEqualToString:chlModel.chapter_name]) {
                        clModel=chlModel;
                    }
                }
            }
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            model.read_chapter_name=clModel.chapter_name;
            [[DatabaseManager sharedDatabaseManager]saveComic:model];
            [cpVC setValue:model forKey:@"theCdModel"];
            [cpVC setValue:clModel forKey:@"theChapterList"];
            [self.collectionView reloadData];
            [self.navigationController pushViewController:cpVC animated:YES];
        });
    });
    
    }
}

/**
 显示header内容
 */
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headerView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *titleLabel=[headerView viewWithTag:1];
    titleLabel.text=@"";
    headerView.backgroundColor=[UIColor whiteColor];
    if (indexPath.section==1) {
        titleLabel.text=@"相关推荐";
    }
    if (indexPath.section>1) {
    if (self.chapterArray.count>0) {
    ChapterModel *model=self.chapterArray[indexPath.section-2];
    titleLabel.text=model.chapter_type;
    }
    
    return headerView;
    }

    return headerView;
}

/**
 设置header大小
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(self.view.frame.size.width, 45);
    
}
/**
 设置cell大小
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return CGSizeMake(kScreenWidth,250);
    }
    if (indexPath.section==1) {
        return CGSizeMake(kScreenWidth, 120);
    }
    CGFloat cellx = (self.collectionView.frame.size.width - 5 * 10)/4.0f;
    
    return CGSizeMake(cellx,27);
    
    
}
/**
 设置cell之间的间隔距离
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    if (section==0) {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (section==1) {
         return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chapterShow"]) {
        UIViewController *destVC=segue.destinationViewController;
        
        NSIndexPath *indexPath=[self.collectionView indexPathForCell:sender];
        NSInteger row=indexPath.row;
        NSInteger section=indexPath.section-2;
        ChapterListModel *clModel=self.chapterListArray[section][row];
        
        ComicDescModel *model=self.dataArray.firstObject;
        NSInteger iscoll=0;
        iscoll=[[DatabaseManager sharedDatabaseManager]selectedModel
                :model].isColl;
        if (iscoll==1) {
            model.isColl=1;
        }
        else{
            model.isColl=0;
        }
        model.read_chapter_name=clModel.chapter_name;
        
        [[DatabaseManager sharedDatabaseManager]saveComic:model];
        [self.collectionView reloadData];
        [destVC setValue:model forKey:@"theCdModel"];
        [destVC setValue:clModel forKey:@"theChapterList"];
    }
}


@end
