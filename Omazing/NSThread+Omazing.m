// NSThread+Omazing.m
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
//
// Based on http://www.informit.com/blogs/blog.aspx?uk=Ask-Big-Nerd-Ranch-Blocks-in-Objective-C
// and google-toolbox-for-mac

#import "NSThread+Omazing.h"

@implementation NSThread (Omazing)

#if NS_BLOCKS_AVAILABLE

+ (void)omz_runBlock:(void (^)())block
{
    block();
}

+ (void)omz_performBlockOnMainThread:(void (^)())block
{
    [[NSThread mainThread] omz_performBlock:block];
}

+ (void)omz_performBlockInBackground:(void (^)())block
{
    [NSThread performSelectorInBackground:@selector(omz_runBlock:)
                               withObject:[block copy]];
}

- (void)omz_performBlock:(void (^)())block
{
    if ([[NSThread currentThread] isEqual:self])
        block();
    else
        [self omz_performBlock:block waitUntilDone:NO];
}

- (void)omz_performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
    [NSThread performSelector:@selector(omz_runBlock:)
                     onThread:self
                   withObject:[block copy]
                waitUntilDone:wait];
}

- (void)omz_performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(omz_performBlock:)
               withObject:[block copy]
               afterDelay:delay];
}

#endif

@end
