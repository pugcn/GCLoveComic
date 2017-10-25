//
//  SearchShowViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/15.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "SearchShowViewController.h"
#import "SortUtility.h"
#import "DIYMjRefreshAutoFooter.h"
#import "DIYMJRefreshHeader.h"
@interface SearchShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBtnItem;

@property (nonatomic,assign) BOOL flag;

@property (nonatomic,assign) int itemCount;

@property (nonatomic,strong) NSArray *menuArray;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy)  NSString *theSearchKey;

@property (nonatomic,strong) PageModel *pageModel;

@property (nonatomic,assign) NSInteger pageNumber;

@property (nonatomic,copy)  NSString *orderByStr;

@property (nonatomic,assign) NSInteger maxPageNumber;

@end

@implementation SearchShowViewController

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
    // 设置导航栏按钮和标题颜色
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    // 设置导航栏颜色
    [self wr_setNavBarBarTintColor:LoveColorFromHexadecimalRGB(0x1874CD)];
    self.pageNumber=1;
    self.orderByStr=@"click";
    [self requseData];
    self.collectionView.mj_header=[DIYMJRefreshHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.pageNumber=1;
        [self requseData];
    }];
    self.collectionView.mj_footer=[DIYMjRefreshAutoFooter footerWithRefreshingBlock:^{
        if (self.pageNumber>self.maxPageNumber) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self requseData];
        }
    }];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.rightBtnItem setImage:[UIImage imageNamed:@"click"]];
    self.flag = YES;
    NSDictionary *dict1 = @{@"imageName" : @"click_l",
                            @"itemName" : @"人气"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"score_l",
                            @"itemName" : @"评分"
                            };
    NSDictionary *dict3 = @{@"imageName" : @"update_l",
                            @"itemName" : @"更新"
                            };
    NSArray *menuArray = @[dict1,dict2,dict3];
    _menuArray = menuArray;
    
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:menuArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
        weakSelf.flag = YES; // 这里的目的是，让rightButton点击，可再次pop出menu
    }];
    self.title=self.theSearchKey;
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.title=@"";
    [CommonMenuView clearMenu];   // 移除菜单
    [super viewWillDisappear:animated];
}


- (IBAction)rightBtnClick:(UIBarButtonItem *)sender {
    [self popMenu:CGPointMake(self.navigationController.view.width - 30, 50)];
}

- (void)popMenu:(CGPoint)point{
    if (self.flag) {
        [CommonMenuView showMenuAtPoint:point];
        self.flag = NO;
    }else{
        [CommonMenuView hidden];
        self.flag = YES;
    }
}

#pragma mark -- 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    [self.dataArray removeAllObjects];
    self.pageNumber=1;
    self.maxPageNumber=0;
    if (tag==1) {
        [self.rightBtnItem setImage:[UIImage imageNamed:@"click"]];
        self.orderByStr=@"click";
        [self requseData];
    }
    if (tag==2) {
        [self.rightBtnItem setImage:[UIImage imageNamed:@"score"]];
        self.orderByStr=@"score";
        [self requseData];
    }
    if (tag==3) {
        [self.rightBtnItem setImage:[UIImage imageNamed:@"update"]];
        self.orderByStr=@"date";
        [self requseData];
    }
    
    [CommonMenuView hidden];
    self.flag = YES;
}


/**
 网络请求数据
 */
-(void)requseData{
    __weak typeof(self) weakSelf = self;
    NSString *link=[NSString stringWithFormat:SearchDetailURL,self.pageNumber,self.orderByStr,self.theSearchKey];
    //转UTF-8
    NSString *url=[link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"====%@===",url);
    [[DownLoadManager sharedDownLoadManager]GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        SortDetailmodel *model=[SortDetailmodel yy_modelWithJSON:responseObject];
        NSArray *arr=model.data;
        PageModel*pageModel=model.page;
        weakSelf.pageNumber=pageModel.current_page+1;
        weakSelf.maxPageNumber=pageModel.total_page;
        for (SortDetailmodel *sdModel in arr) {
            [weakSelf.dataArray addObject:sdModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        });
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"出错了%@",error);
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
    SortDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicdata" forIndexPath:indexPath];
    SortDataModel *sdmodel=self.dataArray[indexPath.row];
    cell.model=sdmodel;
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


#pragma mark -- dealloc:释放菜单
- (void)dealloc{
    [CommonMenuView clearMenu];   // 移除菜单
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"searchtodesc"]) {
        ComicDetailViewController *destVC=segue.destinationViewController;
        NSIndexPath *indexPath=[self.collectionView indexPathForCell:sender];
        destVC.hidesBottomBarWhenPushed = YES;
        if (self.dataArray.count>0) {
            
            SortDataModel *dmodel=self.dataArray[indexPath.row];
            destVC.comic_id=dmodel.comic_id;
        }
    }
    
}

@end
