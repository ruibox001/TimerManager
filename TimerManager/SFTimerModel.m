//
//  SFTimerModel.m
//  TimerManager
//
//  Created by 王声远 on 2017/6/26.
//  Copyright © 2017年 王声远. All rights reserved.
//

#import "SFTimerModel.h"

@implementation SFTimerModel

- (instancetype) initWithSec:(int)sec key:(NSString *)key block:(void (^)())block
{
    self = [super init];
    if (self) {
        _timeKey = key;
        _timeSec = sec;
        _timeBlock = block;
    }
    return self;
}
@end
