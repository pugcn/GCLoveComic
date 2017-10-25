//
//  ChapterViewController.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/8.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ChapterViewController.h"
#import "ComicUtility.h"
#import "LightChangeManger.h"
#import "XFAlertView.h"
#import "DatabaseManager.h"
#import "HWProgressView.h"

@interface ChapterViewController ()<UIScrollViewDelegate,XFAlertViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) HWProgressView *progressView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray *dataArray;
/**用来保存每张图片高度的数组*/
@property(nonatomic,strong) NSMutableArray *hightArr;

/**用来保存每张图片尺寸的数组*/
@property(nonatomic,strong) NSMutableArray *sizArr;

@property(nonatomic,assign) CGFloat  systemLight;

@property (nonatomic,strong) ChapterListModel *theChapterList;

@property (nonatomic,strong) ComicDescModel *theCdModel;


@end

@implementation ChapterViewController{
    
    UIView *topView;
    UILabel *label;
    UIView *bottomView;
    NSInteger currenNumber;
}

#pragma mark 懒加载
-(NSMutableArray *)hightArr{
    if (!_hightArr) {
        _hightArr=[[NSMutableArray alloc]init];
    }
    
    return  _hightArr;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    
    return  _dataArray;
    
}
-(NSMutableArray *)sizArr{
    if (!_sizArr) {
        _sizArr=[[NSMutableArray alloc]init];
    }
    
    return  _sizArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self wr_setNavBarBackgroundAlpha:0];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    HWProgressView *progressView = [[HWProgressView alloc] initWithFrame:CGRectMake(45, 350, kScreenWidth-90, 20)];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    //记录手机系统亮度并设置电子书亮度
    self.systemLight = [[UIScreen mainScreen] brightness];
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [[UIScreen mainScreen] setBrightness:[[LightChangeManger sharedLightChangeManger] brightness]];
    [self creatUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1.8), dispatch_get_main_queue(), ^{
        // show statusbar
        [self requestData];
    });
    
}
- (void)timerAction
{
    
    _progressView.progress += 0.01;
    
    
    if (_progressView.progress >= 1) {
        [self removeTimer];
        [self.progressView setHidden:YES];
        NSLog(@"完成");
    }
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    
    //设置手机系统亮度
    [[UIScreen mainScreen] setBrightness:self.systemLight];
    
    [super viewWillDisappear:animated];
    
}
- (void)alertView:(XFAlertView *)alertView didClickTitle:(NSString *)title{
    if ([title isEqualToString:@"收藏"]) {
        ComicDescModel *model=[[DatabaseManager sharedDatabaseManager]selectedModel:self.theCdModel];
        model.isColl=1;
        [[DatabaseManager sharedDatabaseManager]saveComic:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



#pragma mark 创建界面
-(void)creatUI{
    
    //    self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView=[[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    self.scrollView.delegate =self;
    self.scrollView.userInteractionEnabled=YES;
    //    [self.view addSubview:self.scrollView];
    
    //添加手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [self.scrollView addGestureRecognizer:tap];
    
    //创建点击弹出视图
    
    topView =[[UIView alloc] init];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
        
    }];
    topView.backgroundColor =[UIColor blackColor];
    topView.alpha=0;
    //返回按钮
    UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 30, 30)];
    
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.backgroundColor =[UIColor clearColor];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    //章节 进度显示
    label =[[UILabel alloc] init];
    [topView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(300);
        
    }];
    
    //创建底部弹出视图
    bottomView =[[UIView alloc] init];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@49);
        
        
    }];
    bottomView.backgroundColor=[UIColor blackColor];
    bottomView.alpha=0;
    //横竖屏 控制按钮
    UIButton *landScapeBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 49 ,49)];
    [landScapeBtn setImage:[UIImage imageNamed:@"changeread"] forState:UIControlStateNormal];
    [landScapeBtn addTarget:self action:@selector(landScape:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:landScapeBtn];
    //亮度调节
    
    UISlider *lightSld=[[UISlider alloc]init];
    lightSld.value=self.systemLight;
    [bottomView addSubview:lightSld];
    [lightSld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@35);
    }];
    [lightSld setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [lightSld addTarget:self action:@selector(changeLight:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *darkimageView=[[UIImageView alloc]init];
    [bottomView addSubview:darkimageView];
    [darkimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(lightSld).offset(-16);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@20);
    }];
    darkimageView.image=[UIImage imageNamed:@"dark"];
    UIImageView *lightimageView=[[UIImageView alloc]init];
    [bottomView addSubview:lightimageView];
    [lightimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(lightSld).offset(25);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@20);
    }];
    lightimageView.image=[UIImage imageNamed:@"light"];
    
    
}
-(void)requestData{
    self.theChapter=self.theChapterList.chapter_source;
    ChapterSourceModel *csModel=self.theChapter.firstObject;
    
    NSString *url=nil;
    if (csModel.chapter_domain.length>1) {
        url=[NSString stringWithFormat:ChapterURL_1,csModel.chapter_domain,@"%@"];
    }
    else{
        url=ChapterURL_2;
    }
    NSArray *strArr=[csModel.rule componentsSeparatedByString:@"$"];
    if (strArr==nil) {
        XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                           Msg:@"大人，该漫画已被遣送回阿里嘎多星球"                                        CancelBtnTitle:@"确定"
                                                    OKBtnTitle:nil
                                                           Img:[UIImage imageNamed:@"collcover"]];
        [alert show];
        
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=(short)csModel.start_num; i<csModel.end_num+1; i++) {
            
            // 处理耗时操作的代码块...
            NSString *urlStr=[NSString stringWithFormat:@"%@%d.jpg",strArr.firstObject,i];
            NSString *dataUrl=[NSString stringWithFormat:url,urlStr];
            //转UTF-8
            NSString *imgUrl=[dataUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSLog(@"====%@",dataUrl);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            UIImage *image = [UIImage sd_imageWithData:data];
            //通知主线程刷新
            if (image!=nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData:image];
                });
            }
            else{
                XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                                   Msg:@"大人，该漫画已被遣送回阿里嘎多星球"                                        CancelBtnTitle:@"确定"
                                                            OKBtnTitle:nil
                                                                   Img:[UIImage imageNamed:@"collcover"]];
                [alert show];
                
            }
        }
    });
    
}

#pragma mark 加载数据

-(void)reloadData:(UIImage *)image{
    CGFloat AllHight=0;
    
    CGFloat imgW=kScreenWidth;
    
    //计算图片比例
    
    
    CGFloat scale=image.size.height/image.size.width;
    
    CGFloat imgH=scale*imgW;
    
    CGFloat imgY=0;
    NSString *str=[NSString stringWithFormat:@"%lf",imgH];
    
    for (int i=0; i<self.hightArr.count; i++) {
        
        imgY+=[self.hightArr[i] floatValue];
    }
    [self.hightArr addObject:str];
    UIImageView *imageView =[[UIImageView alloc] init];
    [self.scrollView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.scrollView).offset(imgY);
        make.height.mas_equalTo(@(imgH));
        
    }];
    imageView.image=image;
    
    
    for (int i=0; i<self.hightArr.count; i++) {
        
        AllHight+=[self.hightArr[i] floatValue];
    }
    self.scrollView.contentSize=CGSizeMake(0, AllHight);
    
    
    
}


/**
 亮度调节，需真机
 */
-(void)changeLight:(UISlider *)sender{
    CGFloat currentLight = (CGFloat)sender.value;
    
    [LightChangeManger sharedLightChangeManger].brightness = currentLight;
    
    [[UIScreen mainScreen] setBrightness: currentLight];
    
}
#pragma mark 横屏点击
-(void)landScape:(UIButton *)sender{
    static int i =0;
    if (i==0) {
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
        i++;
    }else{
        
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
        i--;
        
    }
    
    
    
}

#pragma mark 返回点击
-(void)back{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    NSInteger isColl=[[DatabaseManager sharedDatabaseManager]selectedModel:self.theCdModel].isColl;
    if (isColl==0) {
        XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                           Msg:@"收藏收藏，找我更方便哦！"                                        CancelBtnTitle:@"取消"
                                                    OKBtnTitle:@"收藏"
                                                           Img:[UIImage imageNamed:@"collcover"]];
        alert.delegate=self;
        [alert show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 手势方法
-(void)tap:(UITapGestureRecognizer *)tap{
    
    
    CGPoint point =   [tap locationInView:self.view];
    if (point.y<=self.view.frame.size.height/3.0f && self.scrollView.contentOffset.y>0) {
        
        self.scrollView.contentOffset = CGPointMake(0,self.scrollView.contentOffset.y-self.view.frame.size.height/2.0f );
        [self setLabelText];
    }else if(point.y>=self.view.frame.size.height/3.0f*2 && self.scrollView.contentOffset.y<self.scrollView.contentSize.height-self.view.frame.size.height){
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y+self.view.frame.size.height/2.0f);
        [self setLabelText];
    }else{
        
        if (topView.alpha==0) {
            topView.alpha = 0.8;
            bottomView.alpha=0.8;
            [self setLabelText];
        }else{
            topView.alpha = 0;
            bottomView.alpha = 0 ;
        }
        
    }
    
}



#pragma  mark UIScrollViewDelegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    topView.alpha = 0;
    bottomView.alpha=0;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setLabelText];
}


-(void)setLabelText{
    NSInteger AllHight=0;
    for (int i=0; i<self.hightArr.count; i++) {
        
        AllHight+=[self.hightArr[i] floatValue];
        NSInteger a=self.scrollView.contentOffset.y+[self.hightArr[0] floatValue];
        if (a<AllHight && AllHight<a+[self.hightArr[i] floatValue]) {
            currenNumber=i+1;
        }
        
    }
    ChapterSourceModel *csModel=self.theChapter.firstObject;
    
    NSString *chapterName=self.theChapterList.chapter_name;
    if (chapterName.length>5) {
        chapterName=[chapterName substringToIndex:6];
    }
    label.text =[NSString stringWithFormat:@"%@   %ld/%ld",chapterName,currenNumber,csModel.end_num-csModel.start_num+1];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=1;
    
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
