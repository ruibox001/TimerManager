//
//  ViewController.m
//  TimerManager
//
//  Created by 王声远 on 2017/6/26.
//  Copyright © 2017年 王声远. All rights reserved.
//

#import "ViewController.h"
#import "SFTimerManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SFTimerManager registerOneSecondObserver:self timeUpBlock:^{

    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SFTimerManager removeSecondsObserver:self];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
