//
//  NSTimer+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 1/8/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Omazing)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)yesOrNo;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)())block repeats:(BOOL)yesOrNo;


@end
