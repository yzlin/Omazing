// NSThread+OmazingTests.m
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

@interface SSWorkerThreadForTesting : NSThread

- (void)workerMain:(id)object;

@end

@implementation SSWorkerThreadForTesting

- (void)workerMain:(id)object
{
    @autoreleasepool {
        while (!self.isCancelled) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

@end

SpecBegin(NSThread)

describe(@"NSThread", ^{
    __block BOOL isBlockPerformed;
    __block SSWorkerThreadForTesting *workerThread;

    beforeAll(^{
        [Expecta setAsynchronousTestTimeout:5.0];
    });

    beforeEach(^{
        isBlockPerformed = NO;
        workerThread = [SSWorkerThreadForTesting alloc];
        workerThread = [workerThread initWithTarget:workerThread selector:@selector(workerMain:) object:nil];
        [workerThread start];
    });

    afterEach(^{
        [workerThread cancel];
        workerThread = nil;
    });

    afterAll(^{
        [Expecta setAsynchronousTestTimeout:1.0];
    });

    it(@"should perform block on worker thread", ^{
        [workerThread omz_performBlock:^{
            isBlockPerformed = YES;
        }];

        expect(isBlockPerformed).will.to.equal(YES);
    });

    it(@"should perform block on worker thread and wait until done", ^{
        [workerThread omz_performBlock:^{
            isBlockPerformed = YES;
        } waitUntilDone:YES];

        expect(isBlockPerformed).to.equal(YES);
    });

    it(@"should perform block on worker thread after 2-sec delay", ^{
        [workerThread omz_performBlock:^{
            isBlockPerformed = YES;
        } afterDelay:2.0];

        expect(isBlockPerformed).will.to.equal(YES);
    });

    it(@"should perform block in background", ^{
        [NSThread omz_performBlockInBackground:^{
            isBlockPerformed = YES;
        }];

        expect(isBlockPerformed).will.to.equal(YES);
    });
});

SpecEnd
