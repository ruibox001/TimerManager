//
//  SFTimerManager.h
//  SofficeMoi
//
//  Created by Eayon on 16/12/9.
//  Copyright © 2016年 Soffice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFTimerManager : NSObject

//添加时间监听（成对存在）
+ (void)registerSecondsChangeObserver:(id)observer timeChangeBlock:(void (^)())block;

//移除时间监听（成对存在）
+ (void)removeSecondsObserver:(id)observer;

@end
