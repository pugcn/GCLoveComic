//
//  BookshelfViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/9/8.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "BookshelfViewController.h"
#import "XXPageTabView.h"
#import "SortUtility.h"
#import "CollectionViewController.h"
#import "HistoryViewController.h"

@interface BookshelfViewController ()<XXPageTabViewDelegate>
{
    BOOL _done; //是否翻页完成
    NSInteger _currentPage;//当前控制器对应下标
    BOOL isgad;
    UIButton *clBtn;
}

@property (nonatomic, strong) XXPageTabView *pageTabView;

@end

@implementation BookshelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=LoveColorFromHexadecimalRGB(0xf7f7f7);
    self.iscoll=YES;
    isgad=NO;
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.title=@"书架";
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self wr_setNavBarBackgroundAlpha:0];
    [super viewWillDisappear:animated];
}
-(void)setUI{
    CollectionViewController *cvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"collection"];
     
    [self addChildViewController:cvc];
    HistoryViewController *hivc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"hivc"];
    [self addChildViewController:hivc];
    NSArray *titles = @[@"收藏",@"历史"];
    
    self.pageTabView = [[XXPageTabView alloc] initWithChildControllers:self.childViewControllers childTitles:titles];
    self.pageTabView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    self.pageTabView.delegate = self;
    self.pageTabView.titleStyle = XXPageTabTitleStyleDefault;
    self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleDefault;
    self.pageTabView.selectedTabIndex = 0;
    self.pageTabView.tabItemFont = [UIFont systemFontOfSize:16];
    self.pageTabView.maxNumberOfPageItems=2;
    self.pageTabView.indicatorHeight = 3.5;
    self.pageTabView.indicatorWidth = 23;
    self.pageTabView.selectedColor=[UIColor whiteColor];
    self.pageTabView.unSelectedColor=LoveColorFromHexadecimalRGB(0xD9D9D9);
    self.pageTabView.tabSize = CGSizeMake(self.view.bounds.size.width-200, 0);
    UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 1, 38, 38)];
    
    
    clBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-75, 1, 38, 38)];
    clBtn.backgroundColor=LoveColorFromHexadecimalRGB(0x1874CD);
    [clBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [clBtn addTarget:self action:@selector(clAction:) forControlEvents:UIControlEventTouchUpInside];
    [clBtn setHidden:YES];
    [self.pageTabView addSubview:clBtn];
    
    deleteBtn.backgroundColor=LoveColorFromHexadecimalRGB(0x1874CD);
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=LoveColorFromHexadecimalRGB(0x1874CD);
    [self.pageTabView addSubview:deleteBtn];
   
    [self.view addSubview:self.pageTabView];
}

//- (UIViewController *)makeVC {
//    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sortlist"];
//    return vc;
//}
-(void)deleteAction:(id)sender{
    
    
    if (_delegate && self.iscoll==YES) {
        if ([_delegate respondsToSelector:@selector(delAction:)]) {
            [_delegate delAction:sender];
        }
    }
    else {
        if ([_hdelegate respondsToSelector:@selector(delAction:)]) {
            [_hdelegate delAction:sender];
      }
    }
}

-(void)clAction:(id)sender{
    if (_delegate && self.iscoll==YES) {
        if ([_delegate respondsToSelector:@selector(garAction:)]) {
            [_delegate garAction:sender];
        }
    }
    else {
        if (isgad==YES) {
            isgad=NO;
            [clBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        }
        else{
            isgad=YES;
            [clBtn setImage:[UIImage imageNamed:@"gird"] forState:UIControlStateNormal];
        }
        if ([_hdelegate respondsToSelector:@selector(garAction:)]) {
            [_hdelegate garAction:sender];
        }
    }
}

#pragma mark - XXPageTabViewDelegate
- (void)pageTabViewDidEndChange {
    NSLog(@"第%d页", (int)self.pageTabView.selectedTabIndex);
    if (self.pageTabView.selectedTabIndex==0) {
        self.iscoll=YES;
        [clBtn setHidden:YES];
    }
    else{
        self.iscoll=NO;
        [clBtn setHidden:NO];
    }
    
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
