//
//  NSThread+OmazingTests.m
//  Omazing
//
//  Created by Ethan Lin on 9/23/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

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
        [workerThread performBlock:^{
            isBlockPerformed = YES;
        }];

        expect(isBlockPerformed).will.to.equal(YES);
    });

    it(@"should perform block on worker thread and wait until done", ^{
        [workerThread performBlock:^{
            isBlockPerformed = YES;
        } waitUntilDone:YES];

        expect(isBlockPerformed).to.equal(YES);
    });

    it(@"should perform block on worker thread after 2-sec delay", ^{
        [workerThread performBlock:^{
            isBlockPerformed = YES;
        } afterDelay:2.0];

        expect(isBlockPerformed).will.to.equal(YES);
    });

    it(@"should perform block in background", ^{
        [NSThread performBlockInBackground:^{
            isBlockPerformed = YES;
        }];

        expect(isBlockPerformed).will.to.equal(YES);
    });
});

SpecEnd
