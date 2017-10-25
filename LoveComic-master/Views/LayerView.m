//
//  LayerView.m
//  LoveComic-master
//
//  Created by puguichuan on 17/7/29.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "LayerView.h"
#import <Masonry.h>
@implementation LayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    CALayer *cellImageLayer = self.layer;
    [cellImageLayer setCornerRadius:5];
    [cellImageLayer setMasksToBounds:YES];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer.bounds = self.layer.bounds;
    gradientLayer.borderWidth = 0;
    gradientLayer.frame = self.layer.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor blackColor] CGColor], nil ,nil];
    
    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
}


@end
