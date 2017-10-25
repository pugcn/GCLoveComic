//
//  ComicSortViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/16.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ComicSortViewController.h"
#import "SortUtility.h"
#import "SortListViewController.h"
#import "XXPageTabView.h"
#import <PYSearch/PYSearch.h>
@interface ComicSortViewController ()<UIScrollViewDelegate,PYSearchViewControllerDelegate,XXPageTabViewDelegate>
{
    BOOL _done; //是否翻页完成
    NSInteger _currentPage;//当前控制器对应下标
}

@property (nonatomic, strong) XXPageTabView *pageTabView;

@property (nonatomic,strong) NSMutableArray *sortListArray;
@end

@implementation ComicSortViewController


#pragma mark 懒加载

-(NSMutableArray *)sortListArray
{
    if (!_sortListArray) {
        _sortListArray=[[NSMutableArray alloc]init];
    }
    return _sortListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=LoveColorFromHexadecimalRGB(0xf7f7f7);
    [self requseData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.title=@"书库";
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
/**
 网络请求数据
 */
-(void)requseData{
    __weak typeof(self) weakSelf = self;
    [[DownLoadManager sharedDownLoadManager]GET:ComicSortURL parameters:nil success:^(id  _Nonnull responseObject) {
        ComicSortModel *model=[ComicSortModel yy_modelWithJSON:responseObject];
        NSArray *arr =model.comic_sort;
        for (ComicSortListModel *csModel in arr) {
            [weakSelf.sortListArray addObject:csModel];
        }
        
        [self setUI];
        
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"出错了%@",error);
        [self setUI];
    }];
}



-(void)requsetHotSearch{
    [[DownLoadManager sharedDownLoadManager]GET:HotSearchURL parameters:nil success:^(id  _Nonnull responseObject) {
        NSArray *arr=responseObject;
        NSMutableArray *hotSearchArray=[NSMutableArray new];
        for (int i=0; i<arr.count; i++) {
            DataModel *hotSearchModel=[DataModel yy_modelWithJSON:arr[i]];
            [hotSearchArray addObject:hotSearchModel.comic_name];
        }
        [self setSearch:hotSearchArray];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"出错了%@",error);
    }];
}




-(void)setUI{
    for (int i=0; i<6; i++) {
        UIViewController *vc=[self makeVC];
        if (self.sortListArray.count>0) {
            NSMutableArray *sarr=[NSMutableArray new];
            [sarr addObject:self.sortListArray[i]];
            [vc setValue:sarr forKey:@"theSortArray"];
        }
        [self addChildViewController:vc];
        
    }
    NSArray *titles = @[@"剧情",@"地区",@"进度",@"色彩",@"杂志",@"专题"];
    
    self.pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:titles];
    self.pageTabView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    self.pageTabView.delegate = self;
    self.pageTabView.titleStyle = XXPageTabTitleStyleDefault;
    self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleDefault;
    self.pageTabView.selectedTabIndex = 0;
    self.pageTabView.tabItemFont = [UIFont systemFontOfSize:16];
    self.pageTabView.maxNumberOfPageItems=5;
    self.pageTabView.indicatorHeight = 3.5;
    self.pageTabView.indicatorWidth = 23;
    self.pageTabView.selectedColor=[UIColor whiteColor];
    self.pageTabView.unSelectedColor=LoveColorFromHexadecimalRGB(0xD9D9D9);
    self.pageTabView.tabSize = CGSizeMake(self.view.bounds.size.width-40, 0);
    UIButton *searchbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 1, 38, 38)];
    searchbtn.backgroundColor=LoveColorFromHexadecimalRGB(0x1874CD);
    [searchbtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=LoveColorFromHexadecimalRGB(0x1874CD);
    [self.pageTabView addSubview:searchbtn];
    [self.view addSubview:self.pageTabView];
}

- (UIViewController *)makeVC {
    SortListViewController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sortlist"];;
    return vc;
}

-(void)searchAction:(id)sender{
    [self requsetHotSearch];
}

-(void)setSearch:(NSMutableArray *)array{
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:array searchBarPlaceholder:@"搜索漫画名" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        UIViewController *svc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
        [svc setValue:searchText forKey:@"theSearchKey"];
        self.title=@"";
        [searchViewController.navigationController pushViewController:svc animated:YES];
    }];
    // 3. 设置风格
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    
    searchViewController.searchSuggestionHidden=YES;
    // 4. 设置代理
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}


#pragma mark - XXPageTabViewDelegate
- (void)pageTabViewDidEndChange {
    NSLog(@"第%d页", (int)self.pageTabView.selectedTabIndex);
    [self setTabBarHidden:NO];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
