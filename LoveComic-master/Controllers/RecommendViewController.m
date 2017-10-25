//
//  RecommendViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/7/24.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendUtility.h"
#import "RankingViewController.h"
#import "UpDateViewController.h"
#import "ReListViewController.h"
#import "DIYMJRefreshHeader.h"
#import "XFAlertView.h"
#import <PYSearch/PYSearch.h>
#import "ProcessLaunchImageView.h"
@interface RecommendViewController ()<UIScrollViewDelegate,PYSearchViewControllerDelegate,XXPageTabViewDelegate,RefreshDelegate,XFAlertViewDelegate>
{
    BOOL _done; //是否翻页完成
    NSInteger _currentPage;//当前控制器对应下标
}

@property (nonatomic, strong) XXPageTabView *pageTabView;

@property (nonatomic,strong) NSMutableArray *reommendArrary;

@property(nonatomic,strong)  RecommendModel *recomeendModel;

@property(nonatomic,strong)  NSMutableArray *hotSearchArray;



@end

@implementation RecommendViewController



#pragma mark 懒加载

-(NSMutableArray *)reommendArrary
{
    if (!_reommendArrary) {
        _reommendArrary=[[NSMutableArray alloc]init];
    }
    return _reommendArrary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=LoveColorFromHexadecimalRGB(0xf7f7f7);
    // Do any additional setup after loading the view.
   [self requseData];

    //引导页
    [[UIApplication sharedApplication].keyWindow addSubview:[ProcessLaunchImageView initShareView:self.view.bounds bgImageName:@"star" ShowType:ButtonTitleTimeShowType Time:5 ResultBlock:^{
        NSLog(@"我点击了UIImageView");
    }]];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
     self.title=@"推荐";
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self wr_setNavBarBackgroundAlpha:0];
    [super viewWillDisappear:animated];
}




/**
 网络请求数据
 */
-(void)requseData{
    __weak typeof(self) weakSelf = self;
     [weakSelf.reommendArrary removeAllObjects];
    [[DownLoadManager sharedDownLoadManager]GET:RecommendListURL parameters:nil success:^(id  _Nonnull responseObject) {
       
        NSArray *arr =responseObject;
        for (int i=0; i<arr.count; i++) {
             weakSelf.recomeendModel=[RecommendModel yy_modelWithJSON:arr[i]];
            [weakSelf.reommendArrary addObject:weakSelf.recomeendModel];
        }
        if (weakSelf.delegate) {
            NSMutableArray *rearr=[NSMutableArray new];
            [rearr addObject:weakSelf.reommendArrary[(int)self.pageTabView.selectedTabIndex-2]];
            if ([weakSelf.delegate respondsToSelector:@selector(sendRecomend:)]) {
                [weakSelf.delegate sendRecomend:rearr];
            }
        }
        if (self.childViewControllers.count<1) {
            [self setUI];
        }

    } failure:^(NSError * _Nonnull error) {
        NSLog(@"出错了%@",error);
        XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                           Msg:@"网络好像有问题，刷新试试"                                        CancelBtnTitle:@"刷新"
                                                    OKBtnTitle:nil
                                                           Img:[UIImage imageNamed:@"collcover"]];
        alert.delegate=self;
        [alert show];
        if (weakSelf.delegate) {
                        NSMutableArray *rearr=[NSMutableArray new];
            if (weakSelf.reommendArrary.count>0) {
                
            [rearr addObject:weakSelf.reommendArrary[(int)self.pageTabView.selectedTabIndex]];
            }
            if ([weakSelf.delegate respondsToSelector:@selector(sendRecomend:)]) {
                [weakSelf.delegate sendRecomend:rearr];
            }
        }
    }];
}

- (void)alertView:(XFAlertView *)alertView didClickTitle:(NSString *)title{
    [self requseData];
    
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




-(void)setUI{
    
   
    RankingViewController *rvc =[[RankingViewController alloc]init];;
    [self addChildViewController:rvc];
    UpDateViewController *uvc=[[UpDateViewController alloc]init];
    [self addChildViewController:uvc];
    for (int i=0; i<5; i++) {
        UIViewController *vc=[self makeVC];
        [vc setValue:self forKey:@"delegate"];
        if (self.reommendArrary.count>0) {
            NSMutableArray *rearr=[NSMutableArray new];
            [rearr addObject:self.reommendArrary[i]];
            [vc setValue:rearr forKey:@"theRecommendArray"];
        }
        [self addChildViewController:vc];
        
    }
    NSArray *titles = @[@"排行",@"更新",@"热门",@"国漫",@"日漫",@"港台",@"新番"];
    
    self.pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:titles];
    self.pageTabView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    self.pageTabView.delegate = self;
    self.pageTabView.titleStyle = XXPageTabTitleStyleDefault;
    self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleDefault;
    self.pageTabView.selectedTabIndex = 2;
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

/**
 创建控制器方法
 */
- (UIViewController *)makeVC {
    ReListViewController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"relist"];
    return vc;
}

-(void)berefresh{
    
    [self requseData];
}
-(void)searchAction:(id)sender{
    [self requsetHotSearch];
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
