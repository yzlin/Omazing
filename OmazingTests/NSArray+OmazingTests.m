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

    context(@"when array is [0..5]", ^{
        __block NSArray *array;

        beforeAll(^{
            array = @[ @0, @1, @2, @3, @4, @5 ];
        });

        afterAll(^{
            array = nil;
        });

        it(@"should be true when checking if all items are < 10", ^{
            expect([array all:^BOOL(id x) { return [x intValue] < 10; }]).to.beTruthy();
        });

        it(@"should be false when checking if all items are > 3", ^{
            expect([array all:^BOOL(id x) { return [x intValue] > 3; }]).to.beFalsy();
        });

        it(@"should be false when checking if any item is > 10", ^{
            expect([array any:^BOOL(id x) { return [x intValue] > 10; }]).to.beFalsy();
        });

        it(@"should be true when checking if any items is > 3", ^{
            expect([array any:^BOOL(id x) { return [x intValue] > 3; }]).to.beTruthy();
        });

        it(@"should be x^2 when each item maps to function: (x) -> x * x", ^{
            NSArray *result = [array map:^NSNumber *(NSNumber *x) {
                return @([x intValue] * [x intValue]);
            }];
            expect(result).to.haveCountOf([array count]);
            for (int i = 0; i < [result count]; i++) {
                expect(result[i]).to.equal(@([array[i] intValue] * [array[i] intValue]));
            }
        });

        it(@"should be mapped to [NSNull null] with map function: (x) -> nil", ^{
            NSArray *result = [array map:^id(NSNumber *x) { return nil; }];
            expect(result).to.haveCountOf([array count]);
            for (id item in result) {
                expect(item).to.equal([NSNull null]);
            }
        });

        it(@"should be the sum of 15 after reducing", ^{
            expect([array reduce:^NSNumber *(NSNumber *x, NSNumber *y) {
                return @([x intValue] + [y intValue]);
            }]).to.equal(@15);
        });

        it(@"should be empty after filtering all deny", ^{
            expect([array filter:^BOOL(NSNumber *x) { return NO; }]).to.beEmpty();
        });

        it(@"should be equal to source after filtering all pass", ^{
            expect([array filter:^BOOL(NSNumber *x) { return YES; }]).to.equal(array);
        });

        it(@"should be 1 for the first odd integer", ^{
            expect([array firstMatch:^BOOL(NSNumber *x) { return [x intValue] % 2 == 1; }]).to.equal(@1);
        });

        it(@"should be empty after zipping with nil or empty array", ^{
            expect([array zip:nil with:^id(id x, id y) { return x; }]).to.beEmpty();
            expect([array zip:@[] with:^id(id x, id y) { return x; }]).to.beEmpty();
        });

        it(@"should be a sub set, [0..3], after zip with [0..3] with zip function: (x, y) -> y", ^{
            NSArray *expected = @[ @0, @1, @2, @3 ];
            expect([array zip:expected with:^NSNumber *(NSNumber *x, NSNumber *y) { return y; }]).to.equal(expected);
        });

        it(@"should be a sub set, [0..5], after zip with [0..7] with zip function: (x, y) -> y", ^{
            NSArray *expected = @[ @0, @1, @2, @3, @4, @5, @6, @7 ];
            expect([array zip:expected with:^NSNumber *(NSNumber *x, NSNumber *y) { return y; }]).to.equal([expected subarrayWithRange:NSMakeRange(0, 6)]);
        });

        it(@"should be square of each item, after zip with self with zip function: (x, y) -> x * y", ^{
            NSArray *expected = @[ @0, @1, @4, @9, @16, @25 ];
            expect([array zip:array with:^NSNumber *(NSNumber *x, NSNumber *y) {
                return @([x intValue] * [y intValue]);
            }]).to.equal(expected);
        });

        it(@"should be [0] for each key to be the same with unique function", ^{
            NSArray *expected = @[ @0 ];
            expect([array uniq:^id(NSNumber *x) { return nil; }]).to.equal(expected);
            expect([array uniq:^id(NSNumber *x) { return [NSNull null]; }]).to.equal(expected);
            expect([array uniq:^id(NSNumber *x) { return @"key"; }]).to.equal(expected);
        });
    });
});

SpecEnd
