// NSObject+OmazingTests.m
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

SpecBegin(NSObject)

describe(@"NSObject", ^{
    it(@"can add a dealloc block being executed while deallocing", ^{
        __block BOOL isDealloced = NO;
        @autoreleasepool {
            NSMutableString *str = [NSMutableString new];
            [str omz_addDeallocBlock:^{
                isDealloced = YES;
            }];
        }
        expect(isDealloced).to.beTruthy();
    });

    it(@"can add multiple dealloc blocks being executed while deallocing", ^{
        __block BOOL is1stBlockDealloced = NO;
        __block BOOL is2ndBlockDealloced = NO;
        __block BOOL is3rdBlockDealloced = NO;
        @autoreleasepool {
            NSMutableString *str = [NSMutableString new];
            [str omz_addDeallocBlock:^{
                is1stBlockDealloced = YES;
            }];
            [str omz_addDeallocBlock:^{
                is2ndBlockDealloced = YES;
            }];
            [str omz_addDeallocBlock:^{
                is3rdBlockDealloced = YES;
            }];
        }
        expect(is1stBlockDealloced).to.beTruthy();
        expect(is2ndBlockDealloced).to.beTruthy();
        expect(is3rdBlockDealloced).to.beTruthy();
    });
});

SpecEnd
