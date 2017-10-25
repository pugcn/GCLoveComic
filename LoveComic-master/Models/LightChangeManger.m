//
//  LightChangeManger.m
//  LoveComic-master
//
//  Created by puguichuan on 17/8/20.
//  Copyright © 2017年 Pugc. All rights reserved.
//

#import "LightChangeManger.h"

@implementation LightChangeManger
SingleCaseM(LightChangeManger) // 单例实现

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChangeManger"];
        if (data) {
            NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
            LightChangeManger *manager = [unarchive decodeObjectForKey:@"ChangeManger"];
            [manager addObserver:manager forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:NULL];
            return manager;
        }
        
        _brightness = 0.65f;
        
        [self addObserver:self forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:NULL];
        [LightChangeManger updateLocalConfig:self];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [LightChangeManger updateLocalConfig:self];
}
+(void)updateLocalConfig:(LightChangeManger *)manager
{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:manager forKey:@"ChangeManger"];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ChangeManger"];
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.brightness forKey:@"brightness"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.brightness = [aDecoder decodeDoubleForKey:@"brightness"];
    }
    return self;
}


@end
