// NSArray+OmazingTests.m
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

SpecBegin(NSArray)

describe(@"NSArray", ^{

    it(@"should throw exception when block is nil", ^{
        expect(^{
            [@[] any:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] all:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] none:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] each:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] each_i:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] map:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] reduce:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] filter:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] firstMatch:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] zip:@[] with:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@[] uniq:nil];
        }).to.raise(@"NSInvalidArgumentException");
    });

    it(@"-any:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        expect([arr any:^BOOL(NSNumber *x) { return x.intValue > 10; }]).to.beFalsy();
        expect([arr any:^BOOL(NSNumber *x) { return x.intValue > 3; }]).to.beTruthy();
    });

    it(@"-all:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        expect([arr all:^BOOL(NSNumber *x) { return x.intValue < 10; }]).to.beTruthy();
        expect([arr all:^BOOL(NSNumber *x) { return x.intValue > 3; }]).to.beFalsy();
    });

    it(@"-none:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        expect([arr none:^BOOL(NSNumber *x) { return x.intValue < 10; }]).to.beFalsy();
        expect([arr none:^BOOL(NSNumber *x) { return x.intValue > 3; }]).to.beFalsy();
        expect([arr none:^BOOL(NSNumber *x) { return x.intValue < 0; }]).to.beTruthy();
    });

    it(@"-each:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        __block NSMutableArray *result = [NSMutableArray array];
        [arr each:^(NSNumber *x) { [result addObject:x]; }];
        expect(result).to.equal(arr);
    });

    it(@"-each_i:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        __block NSMutableArray *result = [NSMutableArray array];
        __block NSMutableArray *idxResult = [NSMutableArray array];
        [arr each_i:^(NSNumber *x, NSUInteger idx) {
            [result addObject:x];
            [idxResult addObject:@(idx)];
        }];
        expect(result).to.equal(arr);
        expect(idxResult).to.equal(arr);
    });

    it(@"-map:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        NSArray *result = [arr map:^NSNumber *(NSNumber *x) {
            return @(x.intValue * x.intValue);
        }];
        expect(result).to.haveCountOf(arr.count);
        for (int i = 0; i < result.count; i++) {
            expect(result[i]).to.equal(@([arr[i] intValue] * [arr[i] intValue]));
        }

        result = [arr map:^id(NSNumber *x) { return nil; }];
        expect(result).to.haveCountOf(arr.count);
        for (id item in result) {
            expect(item).to.equal([NSNull null]);
        }
    });

    it(@"-reduce:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        expect([arr reduce:^NSNumber *(NSNumber *x, NSNumber *y) {
            return @(x.intValue + y.intValue);
        }]).to.equal(@15);
    });

    it(@"-filter:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        expect([arr filter:^BOOL(NSNumber *x) { return NO; }]).to.beEmpty();
        expect([arr filter:^BOOL(NSNumber *x) { return YES; }]).to.equal(arr);
    });

    it(@"-firstMatch:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        expect([arr firstMatch:^BOOL(NSNumber *x) { return x.intValue % 2 == 1; }]).to.equal(@1);
    });

    it(@"-zip:with:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        expect([arr zip:nil with:^id(id x, id y) { return x; }]).to.beEmpty();
        expect([arr zip:@[] with:^id(id x, id y) { return x; }]).to.beEmpty();

        NSArray *expected = @[ @0, @1, @2, @3 ];
        expect([arr zip:expected with:^NSNumber *(NSNumber *x, NSNumber *y) { return y; }]).to.equal(expected);

        expected = @[ @0, @1, @2, @3, @4, @5, @6, @7 ];
        expect([arr zip:expected with:^NSNumber *(NSNumber *x, NSNumber *y) { return y; }]).to.equal([expected subarrayWithRange:NSMakeRange(0, 6)]);

        expected = @[ @0, @1, @4, @9, @16, @25 ];
        expect([arr zip:arr with:^NSNumber *(NSNumber *x, NSNumber *y) {
            return @(x.intValue * y.intValue);
        }]).to.equal(expected);
    });

    it(@"-uniq:", ^{
        NSArray *arr = @[ @0, @1, @2, @3, @4, @5 ];
        NSArray *expected = @[ @0 ];
        expect([arr uniq:^id(NSNumber *x) { return nil; }]).to.equal(expected);
        expect([arr uniq:^id(NSNumber *x) { return [NSNull null]; }]).to.equal(expected);
        expect([arr uniq:^id(NSNumber *x) { return @"key"; }]).to.equal(expected);
    });
});

SpecEnd
