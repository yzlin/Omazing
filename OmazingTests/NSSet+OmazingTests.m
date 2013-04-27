// NSSet+OmazingTests.m
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

SpecBegin(NSSet)

describe(@"NSSet", ^{

    it(@"should throw exception when block is nil", ^{
        __block NSSet *set = [NSSet set];
        expect(^{
            [set any:nil];
        }).to.raise(@"NSInternalInconsistencyException");
        expect(^{
            [set all:nil];
        }).to.raise(@"NSInternalInconsistencyException");
        expect(^{
            [set none:nil];
        }).to.raise(@"NSInternalInconsistencyException");
        expect(^{
            [set each:nil];
        }).to.raise(@"NSInternalInconsistencyException");
        expect(^{
            [set map:nil];
        }).to.raise(@"NSInternalInconsistencyException");
        expect(^{
            [set reduce:nil];
        }).to.raise(@"NSInternalInconsistencyException");
        expect(^{
            [set filter:nil];
        }).to.raise(@"NSInternalInconsistencyException");
        expect(^{
            [set firstMatch:nil];
        }).to.raise(@"NSInternalInconsistencyException");
    });

    it(@"-any:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        expect([set any:^BOOL(NSNumber *x) { return x.intValue > 10; }]).to.beFalsy();
        expect([set any:^BOOL(NSNumber *x) { return x.intValue > 3; }]).to.beTruthy();
    });

    it(@"-all:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        expect([set all:^BOOL(NSNumber *x) { return x.intValue < 10; }]).to.beTruthy();
        expect([set all:^BOOL(NSNumber *x) { return x.intValue > 3; }]).to.beFalsy();
    });

    it(@"-none:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        expect([set none:^BOOL(NSNumber *x) { return x.intValue < 10; }]).to.beFalsy();
        expect([set none:^BOOL(NSNumber *x) { return x.intValue > 3; }]).to.beFalsy();
        expect([set none:^BOOL(NSNumber *x) { return x.intValue < 0; }]).to.beTruthy();
    });

    it(@"-each:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        __block NSMutableSet *result = [NSMutableSet set];
        [set each:^(NSNumber *x) { [result addObject:x]; }];
        expect(result).to.equal(set);
    });

    it(@"-map:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        NSSet *expected = [NSSet setWithArray:@[ @0, @1, @4, @9, @16, @25 ]];
        NSSet *result = [set map:^NSNumber *(NSNumber *x) {
            return @(x.intValue * x.intValue);
        }];
        expect(result).to.haveCountOf(set.count);
        expect(result).to.equal(expected);

        result = [set map:^id(NSNumber *x) { return nil; }];
        expect(result).to.haveCountOf(1);
        expect(result).to.equal([NSSet setWithObject:[NSNull null]]);
    });

    it(@"-reduce:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        expect([set reduce:^NSNumber *(NSNumber *x, NSNumber *y) {
            return @(x.intValue + y.intValue);
        }]).to.equal(@15);
    });

    it(@"-filter:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        expect([set filter:^BOOL(NSNumber *x) { return NO; }]).to.beEmpty();
        expect([set filter:^BOOL(NSNumber *x) { return YES; }]).to.equal(set);
    });

    it(@"-firstMatch:", ^{
        NSSet *set = [NSSet setWithArray:@[ @0, @1, @2, @3, @4, @5 ]];
        expect([set firstMatch:^BOOL(NSNumber *x) { return [x isEqualToNumber:@1]; }]).to.equal(@1);
    });
});

SpecEnd
