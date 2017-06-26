//
//  SFTimerManager.m
//  SofficeMoi
//
//  Created by Eayon on 16/12/9.
//  Copyright © 2016年 Soffice. All rights reserved.
//

#import "SFTimerManager.h"
#import "SFTimerModel.h"

@interface SFTimerManager ()

@property (strong, nonatomic) NSTimer  *timer;
@property (strong, nonatomic) NSMutableArray *blocks;

@end

@implementation SFTimerManager

- (NSMutableArray *)blocks {
    if (!_blocks) {
        _blocks = [NSMutableArray array];
    }
    return _blocks;
}

+ (instancetype)sharedInstance
{
    static SFTimerManager *item;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        item = [[SFTimerManager alloc]init];
        
        __weak typeof(item) weakSelf = item;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            weakSelf.timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                            target:weakSelf
                                                          selector:@selector(timeSecondChange)
                                                          userInfo:nil
                                                           repeats:YES] ;
            [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    });
    return item;
}

+ (void)registerOneSecondObserver:(id)observer timeUpBlock:(void (^)())block {
    [self registerSeconds:1 observer:observer timeUpBlock:block];
}

+ (void)registerSeconds:(int)sec observer:(id)observer timeUpBlock:(void (^)())block{
    if (sec < 1) {
        return;
    }
    
    if (block && observer) {
        
        NSString *key = [[SFTimerManager sharedInstance] observerClassName:observer];
        if ([[SFTimerManager sharedInstance] observerIsExistWithObserver:key]) {
            NSString *log = [NSString stringWithFormat:@"ERROR >> 该[%@]类只能监听一个block回调，不能重复监听",key];
            NSAssert(NO,log);
            return;
        }
        SFTimerModel *model = [[SFTimerModel alloc] initWithSec:sec key:key block:block];
        [[SFTimerManager sharedInstance].blocks addObject:model];
    }
}

+ (void)removeSecondsObserver:(id)observer
{
    if (observer) {
        NSString *k = [[SFTimerManager sharedInstance] observerClassName:observer];
        for (SFTimerModel *model in [SFTimerManager sharedInstance].blocks) {
            if ([model.timeKey isEqualToString:k]) {
                [[SFTimerManager sharedInstance].blocks removeObject:model];
                break;
            }
        }
    }
}

- (void)timeSecondChange {
    for (SFTimerModel *model in self.blocks) {
        if (model.timeSec == 1) {
            NSLog(@"%@时间到",model.timeKey);
            model.timeBlock(); continue;
        }
        
        model.timeCount ++;
        if (model.timeCount >= model.timeSec) {
            NSLog(@"%@时间到",model.timeKey);
            model.timeBlock();
            model.timeCount = 0;
        }
    }
}

- (BOOL)observerIsExistWithObserver:(NSString *)k
{
    for (SFTimerModel *model in self.blocks) {
        if ([model.timeKey isEqualToString:k]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)observerClassName:(id)observer
{
    return NSStringFromClass([observer class]);
}

@end
