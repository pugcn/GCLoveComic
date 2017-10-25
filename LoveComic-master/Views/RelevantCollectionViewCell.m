//
//  RelevantCollectionViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/23.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "RelevantCollectionViewCell.h"
#import "ComicDetailViewController.h"
#import "LayerView.h"
@interface RelevantCollectionViewCell()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) NSMutableArray *widthArr;

@property(nonatomic,strong) NSMutableArray *reArr;
@end

@implementation RelevantCollectionViewCell


-(NSMutableArray*)widthArr{

    if (!_widthArr) {
        _widthArr=[[NSMutableArray alloc]init];
    }
    return _widthArr;
}

-(NSMutableArray *)reArr{
    if (!_reArr) {
        _reArr=[[NSMutableArray alloc]init];
    }
    return _reArr;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


-(void)setup{
    self.scrollView=[[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    self.scrollView.delegate =self;
    self.scrollView.userInteractionEnabled=YES;
    
}

-(void)setArray:(NSArray *)array{
    _array=array;
    CGFloat AllWidth=0;
    for (int i=0; i<_array.count; i++) {
        RelevantModel *model=_array[i];
        [self.reArr addObject:model];
        CGFloat imgH=120.0;
        CGFloat imgW=90.0;
        //计算图片比例
        
        CGFloat imgX=20;
        
        NSString *str=[NSString stringWithFormat:@"%lf",100.0];
        for (int i=0; i<self.widthArr.count; i++) {
            
            imgX += 100.0;
        }
        [self.widthArr addObject:str];
        UIButton *reBtn =[[UIButton alloc] init];
        reBtn.tag=i;
        CALayer *rebtnLayer = reBtn.layer;
        [rebtnLayer setCornerRadius:5];
        [rebtnLayer setMasksToBounds:YES];
        [self.scrollView addSubview:reBtn];
        [reBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self);
            make.left.equalTo(self.scrollView).offset(imgX);
            make.height.mas_equalTo(@(imgH));
            make.width.mas_equalTo(@(imgW));
            
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *coverUrl=[NSString stringWithFormat:CoverURL,model.cartoon_id];
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];
            UIImage *image = [UIImage sd_imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [reBtn setBackgroundImage:image forState:UIControlStateNormal];
            });
        });
        
        [reBtn addTarget:self action:@selector(reBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *nameView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, imgW, 25)];
        [nameView setUserInteractionEnabled:YES];
        CALayer *cellImageLayer = nameView.layer;
        [cellImageLayer setCornerRadius:5];
        [cellImageLayer setMasksToBounds:YES];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
        gradientLayer.bounds = nameView.layer.bounds;
        gradientLayer.borderWidth = 0;
        gradientLayer.frame = nameView.layer.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor clearColor] CGColor],
                                (id)[[UIColor blackColor] CGColor], nil ,nil];
        
        gradientLayer.startPoint = CGPointMake(0.1, 0.1);
        gradientLayer.endPoint = CGPointMake(0.1, 1.0);
        
        [nameView.layer insertSublayer:gradientLayer atIndex:0];
        [reBtn addSubview:nameView];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 3,90, 20)];
        nameLabel.font=[UIFont fontWithName:@"Helvetica" size:8];
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        nameLabel.text=model.cartoon_name;
        [nameView addSubview:nameLabel];
    }
    for (int i=0; i<self.widthArr.count; i++) {
        
        AllWidth+=[self.widthArr[i] floatValue];;
    }
    self.scrollView.contentSize=CGSizeMake(AllWidth+20, 0);
}

-(void)reBtnClick:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(choseRelevant:)]) {
        [_delegate choseRelevant:sender];
    }
}

@end
