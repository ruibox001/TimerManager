//
//  SFTimerModel.h
//  TimerManager
//
//  Created by 王声远 on 2017/6/26.
//  Copyright © 2017年 王声远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFTimerModel : NSObject

@property (nonatomic,copy) void (^timeBlock)();
@property (nonatomic,strong,readonly) NSString *timeKey;
@property (nonatomic,assign,readonly) int timeSec;
@property (nonatomic,assign) int timeCount;

- (instancetype) initWithSec:(int)sec key:(NSString *)key block:(void (^)())block;

@end
