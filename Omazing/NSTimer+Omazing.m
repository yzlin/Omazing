//
//  NSTimer+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 1/8/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import "NSTimer+Omazing.h"

@implementation NSTimer (Omazing)

+ (void)executeBlockForTimer:(NSTimer *)timer
{
    if (timer.userInfo) {
        void (^block)() = (void (^)())timer.userInfo;
        block();
    }
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)yesOrNo
{
    void (^blk)() = [block copy];
    NSTimer *timer = [self timerWithTimeInterval:ti
                                          target:self
                                        selector:@selector(executeBlockForTimer:)
                                        userInfo:blk
                                         repeats:yesOrNo];
    [blk release];

    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)yesOrNo
{
    void (^blk)() = [block copy];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti
                                                   target:self
                                                 selector:@selector(executeBlockForTimer:)
                                                 userInfo:blk
                                                  repeats:yesOrNo];
    [blk release];

    return timer;
}

@end
