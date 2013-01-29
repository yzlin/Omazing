//
//  NSThread+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 9/23/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//
// Based on http://www.informit.com/blogs/blog.aspx?uk=Ask-Big-Nerd-Ranch-Blocks-in-Objective-C
// and google-toolbox-for-mac

#import "NSThread+Omazing.h"

@implementation NSThread (Omazing)

#if NS_BLOCKS_AVAILABLE

+ (void)runBlock:(void (^)())block
{
    block();
}

+ (void)performBlockOnMainThread:(void (^)())block
{
    [[NSThread mainThread] performBlock:block];
}

+ (void)performBlockInBackground:(void (^)())block
{
    [NSThread performSelectorInBackground:@selector(runBlock:)
                               withObject:[[block copy] autorelease]];
}

- (void)performBlock:(void (^)())block
{
    if ([[NSThread currentThread] isEqual:self])
        block();
    else
        [self performBlock:block waitUntilDone:NO];
}

- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
    [NSThread performSelector:@selector(runBlock:)
                     onThread:self
                   withObject:[[block copy] autorelease]
                waitUntilDone:wait];
}

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(performBlock:)
               withObject:[[block copy] autorelease]
               afterDelay:delay];
}

#endif

@end
