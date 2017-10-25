//
//  UpDateViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/29.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "UpDateViewController.h"
#import "RecommendUtility.h"
#import "UpdateListViewController.h"
@interface UpDateViewController ()<XXPageTabViewDelegate>
{
    BOOL _done; //是否翻页完成
    NSInteger _currentPage;//当前控制器对应下标
}

@property (nonatomic,strong) NSMutableArray *upDateListArray;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic, strong) XXPageTabView *pageTabView;
@end

@implementation UpDateViewController

#pragma mark 懒加载

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[[NSMutableArray alloc]init];
    }
    return _titleArray;
}
-(NSMutableArray *)upDateListArray{
    if (!_upDateListArray) {
        _upDateListArray=[[NSMutableArray alloc]init];
    }
    return _upDateListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageTabView.delegate=self;
    [self requseData];
    
}
/**
 网络请求数据
 */
-(void)requseData{
    __weak typeof(self) weakSelf = self;
    [[DownLoadManager sharedDownLoadManager]GET:UpdateURL parameters:nil success:^(id  _Nonnull responseObject) {
        UpdateModel *model=[UpdateModel yy_modelWithJSON:responseObject];
        NSArray *arr=model.update;
        for (UpDateListModel *ulModel in arr) {
            [weakSelf.upDateListArray addObject:ulModel];
            [weakSelf.titleArray addObject:ulModel.comicUpdateDate];
        }
        if (self.childViewControllers.count<1) {
            [self setUI];
        }
        
    } failure:^(NSError * _Nonnull error) {
    }];
}

-(void)setUI{
    for (int i=0; i<7; i++) {
        UIViewController *vc=[self makeVC];
        if (self.upDateListArray.count>0) {
            NSMutableArray *uparr=[NSMutableArray new];
            [uparr addObject:self.upDateListArray[i]];
            [vc setValue:uparr forKey:@"theUpDateArray"];
        }
        [self addChildViewController:vc];
        
    }
    self.pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:self.titleArray];
    self.pageTabView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.pageTabView.delegate = self;
    self.pageTabView.titleStyle = XXPageTabTitleStyleDefault;
    self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleStretch;
    self.pageTabView.selectedTabIndex = 6;
    self.pageTabView.indicatorHeight = 0;
    self.pageTabView.tabItemFont=[UIFont systemFontOfSize:12];
    self.pageTabView.maxNumberOfPageItems=7;
    self.pageTabView.selectedColor=[UIColor orangeColor];
    self.pageTabView.unSelectedColor=[UIColor blackColor];
    self.pageTabView.tabBackgroundColor=[UIColor whiteColor];
    self.pageTabView.tabSize = CGSizeMake(self.view.bounds.size.width, 0);
    self.pageTabView.tabBackgroundColor=[UIColor whiteColor];
    self.pageTabView.separatorColor=[UIColor darkGrayColor];
    [self.view addSubview:self.pageTabView];
}

/**
 创建控制器方法
 */
- (UIViewController *)makeVC {
    UpdateListViewController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"uplist"];
    vc.isOpen=NO;
    return vc;
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
