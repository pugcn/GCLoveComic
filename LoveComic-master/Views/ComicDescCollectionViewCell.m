//
//  ComicDescCollectionViewCell.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/4.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "ComicDescCollectionViewCell.h"
#import "XFAlertView.h"
#import "DatabaseManager.h"

@implementation ComicDescCollectionViewCell{
    
    NSString *detail;
    UIImage *coverimage;
    NSString *name;
    ComicDescModel *cmodel;
    NSString *readName;
    NSMutableArray<ComicDescModel *> *carr;
    NSInteger iscoll;
}

-(void)setModel:(ComicDescModel *)model{
    _model=model;
     self.backgroundColor=LoveColorFromHexadecimalRGB(0x5CACEE);
    iscoll=0;
    iscoll=[[DatabaseManager sharedDatabaseManager]selectedModel:_model].isColl;
    readName=[[DatabaseManager sharedDatabaseManager]selectedModel:_model].read_chapter_name;
    if (iscoll==0) {
        [self.collBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    }
    else{
        [self.collBtn setImage:[UIImage imageNamed:@"collectioned"] forState:UIControlStateNormal];
    }
    if (readName!=nil) {
        if (readName.length>3) {
            readName=[readName substringToIndex:4];
        }
         [self.readBtn setTitle:[NSString stringWithFormat:@"%@%@",@"续看",readName] forState:0];
    }
    else{
        [self.readBtn setTitle:@"开始阅读" forState:0];
    }
    self.readBtn.layer.masksToBounds = YES;
    self.readBtn.layer.cornerRadius=10;
    self.decsBtn.layer.masksToBounds = YES;
    self.decsBtn.layer.cornerRadius=10;
    if (_model!=nil) {
                cmodel=_model;
        cmodel.last_chapter_name=self.updateName;
        cmodel.comic_id=self.comic_id;
        name=_model.comic_name;
        detail=_model.comic_desc;
        NSMutableString *nameStr=[[NSMutableString alloc]initWithString:name];
        if (nameStr.length>10) {
            //长度太长时将中间省略
            [nameStr replaceCharactersInRange:NSMakeRange(4, 5) withString:@"..."];
        }
        self.namelabel.text=nameStr;
        self.authorLabel.text=_model.comic_author;
        self.updateLabel.text=self.updateName;
        self.updateLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
        NSString *url=[NSString stringWithFormat:CoverURL,self.comic_id];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            coverimage=image;
            if (image!=nil) {
                self.backgroundColor=[UIColor clearColor];
                self.imageView.alpha=1;
                UIImage *lastImage = [image applyDarkEffect];
                self.imageView.image=lastImage;
            }
        }];
        NSDictionary *sortdict=_model.comic_type;
        NSArray *sortArr=sortdict.allValues;
        CGFloat laX=30.0;
        for (int i=0; i<sortArr.count; i++) {
            UIButton *sortBtn=[[UIButton alloc]init];
            sortBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
            sortBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            sortBtn.layer.masksToBounds = YES;
            sortBtn.layer.cornerRadius=8;
            sortBtn.tag=i;
            sortBtn.alpha=0.8;
            CGFloat width=35.0;
            if ([sortArr[i] length]>2) {
                width=55.0;
            }
            [sortBtn setTitle:sortArr[i] forState:0];
            [sortBtn setTitleColor:[UIColor whiteColor] forState:0];
            sortBtn.backgroundColor=[UIColor lightGrayColor];
            [sortBtn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:sortBtn];
            [sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.updateLabel).offset(30);
                make.left.equalTo(self).offset(laX);
                make.height.mas_equalTo(@20);
                make.width.mas_equalTo(width);
            }];
            laX += width+8.0;
            
        }
    

        NSString* uptime=[self ConvertStrToTime:_model.update_time];
        CGFloat uaX=laX+8.0;
        UILabel *updateTimeLabel=[[UILabel alloc]init];
        updateTimeLabel.textColor=[UIColor whiteColor];
        [self addSubview:updateTimeLabel];
        [updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.updateLabel).offset(30);
            make.left.equalTo(self).offset(uaX);
            make.height.mas_equalTo(@20);
        }];
        updateTimeLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
        updateTimeLabel.text= uptime;
    }
    
    
}

/**
 时间戳变为格式时间
 
 @param timeStr 网络获取的时间戳
 @return 格式时间
 */
- (NSString *)ConvertStrToTime:(NSInteger)timeStr

{
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    //    long long time=[timeStr longLongValue] / 1000;
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:timeStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString*timeString=[formatter stringFromDate:date];
    
    return timeString;
    
}
- (IBAction)saveComic:(UIButton *)sender {
    if (iscoll==0) {
        cmodel.isColl=1;
        cmodel.read_chapter_name=readName;
            [[DatabaseManager sharedDatabaseManager]saveComic:cmodel];
        XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                           Msg:@"大人，收藏好了!"                                        CancelBtnTitle:@"确定"
                                                    OKBtnTitle:nil
                                                           Img:[UIImage imageNamed:@"people1"]];
        [alert show];
         [self.collBtn setImage:[UIImage imageNamed:@"collectioned"] forState:UIControlStateNormal];
        iscoll=1;
    }
    else{
        cmodel.isColl=0;
        [[DatabaseManager sharedDatabaseManager]deleateAllComic:cmodel];
        XFAlertView *alert = [[XFAlertView alloc]initWithTitle:nil
                                                           Msg:@"哼，不要我算了!"                                        CancelBtnTitle:@"确定"
                                                    OKBtnTitle:nil
                                                           Img:[UIImage imageNamed:@"people2"]];
        [alert show];
        [self.collBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        iscoll=0;
    }
   
}

-(void)sortAction:(UIButton *)sender{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(choseSort:)]) {
            [_delegate choseSort:sender];
        }
    }
}

- (IBAction)readAction:(UIButton *)sender {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(readClick:)]) {
            [_delegate readClick:sender];
        }
    }
    
}

- (IBAction)detailAction:(UIButton *)sender {
    
    XFAlertView *alert = [[XFAlertView alloc]initWithTitle:name
                                                       Msg:detail
                                            CancelBtnTitle:@"关闭"
                                                OKBtnTitle:nil
                                                       Img:coverimage];
    [alert show];

}


@end
