//
//  LogUtil.m
//  logLevelUp
//
//  Created by chengxun on 16/4/28.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import "LogUtil.h"

@implementation LogUtil
+ (void)setUp{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    DDFileLogger * fileLogger = [[DDFileLogger alloc]init];
    [fileLogger setMaximumFileSize:1024*1024];
    [fileLogger setRollingFrequency:(3600.0*24.0)];
    [[fileLogger logFileManager]setMaximumNumberOfLogFiles:7];
    [DDLog addLogger:fileLogger];
    
    setenv("XcodeColors", "YES", 0);
    [[DDTTYLogger sharedInstance]setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor whiteColor] backgroundColor:[UIColor grayColor] forFlag:DDLogFlagVerbose]; //设置文字为白色，背景为灰色。

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:[UIColor whiteColor] forFlag:DDLogFlagDebug];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor cyanColor] backgroundColor:[UIColor blueColor] forFlag:DDLogFlagInfo];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor lightGrayColor] backgroundColor:[UIColor orangeColor] forFlag:DDLogFlagWarning];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] forFlag:DDLogFlagError];

}

@end
