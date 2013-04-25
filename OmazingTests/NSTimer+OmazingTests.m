// NSTimer+OmazingTests.m
// 
// Copyright (c) 2013 github.com/yzlin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Specta.h>
#define EXP_SHORTHAND
#import <Expecta.h>

#import "Omazing.h"

SpecBegin(NSTimer)

describe(@"NSTimer", ^{
    __block NSTimer *timer = nil;

    beforeAll(^{
        [Expecta setAsynchronousTestTimeout:5.0];
    });

    afterAll(^{
        [Expecta setAsynchronousTestTimeout:1.0];
    });

    it(@"should support performing block without repeat", ^{
        __block BOOL isDone = NO;
        __block size_t count = 0;
        [NSThread performBlockInBackground:^{
            @autoreleasepool {
                NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

                timer = [NSTimer timerWithTimeInterval:1.0 block:^{
                    count++;
                    isDone = (count == 1);
                } repeat:NO];

                [runLoop addTimer:timer forMode:NSRunLoopCommonModes];

                [runLoop run];
            }
        }];

        sleep(3);

        expect(isDone).to.beTruthy();
    });

    it(@"should support performing block with repeat", ^{
        __block BOOL isDone = NO;
        __block size_t count = 0;
        [NSThread performBlockInBackground:^{
            @autoreleasepool {
                NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

                timer = [NSTimer timerWithTimeInterval:1.0 block:^{
                    count++;
                    if (count == 3) isDone = YES;
                } repeat:YES];

                [runLoop addTimer:timer forMode:NSRunLoopCommonModes];

                [runLoop run];
            }
        }];

        expect(isDone).will.to.beTruthy();
    });

    it(@"should directly add itself to current runloop and support performing block without repeat", ^{
        __block BOOL isDone = NO;
        __block size_t count = 0;
        [NSThread performBlockInBackground:^{
            @autoreleasepool {
                NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
                    count++;
                    isDone = (count == 1);
                } repeat:NO];

                [runLoop run];
            }
        }];

        sleep(3);

        expect(isDone).to.beTruthy();
    });

    it(@"should directly add itself to current runloop and support performing block with repeat", ^{
        __block BOOL isDone = NO;
        __block size_t count = 0;
        [NSThread performBlockInBackground:^{
            @autoreleasepool {
                NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
                    count++;
                    if (count == 3) isDone = YES;
                } repeat:YES];

                [runLoop run];
            }
        }];

        expect(isDone).will.to.beTruthy();
    });
});

SpecEnd
