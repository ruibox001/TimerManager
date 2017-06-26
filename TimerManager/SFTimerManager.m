//
//  SFTimerManager.m
//  SofficeMoi
//
//  Created by Eayon on 16/12/9.
//  Copyright © 2016年 Soffice. All rights reserved.
//

#import "SFTimerManager.h"

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

+ (void)registerSecondsChangeObserver:(id)observer timeChangeBlock:(void (^)())block {
    
    if (block && observer) {
        NSString *key = [[SFTimerManager sharedInstance] observerClassName:observer];
        if ([[SFTimerManager sharedInstance] observerIsExistWithObserver:key]) {
            NSString *log = [NSString stringWithFormat:@"ERROR >> 该[%@]类只能监听一个block回调，不能重复监听",key];
            NSAssert(NO,log);
            return;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:block,key, nil];
        [[SFTimerManager sharedInstance].blocks addObject:dict];
    }
}

+ (void)removeSecondsObserver:(id)observer
{
    if (observer) {
        NSString *k = [[SFTimerManager sharedInstance] observerClassName:observer];
        for (NSDictionary *dict in [SFTimerManager sharedInstance].blocks) {
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:k]) {
                    [[SFTimerManager sharedInstance].blocks removeObject:dict];
                    *stop = YES;
                }
            }];
            
        }
    }
}

- (void)timeSecondChange {
    for (NSDictionary *dict in self.blocks) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            void (^block)()  = obj;
            if (block) {
                block();
            }
        }];
    }
}

- (BOOL)observerIsExistWithObserver:(NSString *)k
{
    if (!k) {
        return NO;
    }
    
    for (NSDictionary *dict in self.blocks) {
        if (!dict) {
            return NO;
        }
        
        id obj = [dict objectForKey:k];
        if (obj) {
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
