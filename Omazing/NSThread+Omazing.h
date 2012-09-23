//
//  NSThread+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 9/23/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (Omazing)

#if NS_BLOCKS_AVAILABLE

+ (void)performBlockOnMainThread:(void (^)())block;
+ (void)performBlockInBackground:(void (^)())block;

- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

#endif

@end
