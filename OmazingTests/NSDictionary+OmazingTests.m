// NSDictionary+OmazingTests.m
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

SpecBegin(NSDictionary)

describe(@"NSDictionary", ^{

    it(@"should throw exception when block is nil", ^{
        expect(^{
            [@{} any:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@{} all:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@{} none:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@{} each:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@{} map:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@{} filter:nil];
        }).to.raise(@"NSInvalidArgumentException");
        expect(^{
            [@{} firstMatch:nil];
        }).to.raise(@"NSInvalidArgumentException");
    });

    it(@"-any:", ^{
        NSDictionary *dict = @{ @0: @"zero", @1: @"one", @2: @"two", @3: @"three", @4: @"four", @5: @"five" };
        expect([dict any:^BOOL(NSNumber *k, id v) { return k.intValue > 10; }]).to.beFalsy();
        expect([dict any:^BOOL(NSNumber *k, id v) { return k.intValue > 3; }]).to.beTruthy();
        __block NSUInteger count = 0;
        expect([dict any:^BOOL(NSNumber *k, id v) {
            count++;
            expect(v).to.beKindOf([NSString class]);
            return NO;
        }]).to.beFalsy();
        expect(count).to.equal(dict.count);
    });

    it(@"-all:", ^{
        NSDictionary *dict = @{ @0: @"zero", @1: @"one", @2: @"two", @3: @"three", @4: @"four", @5: @"five" };
        expect([dict all:^BOOL(NSNumber *k, id v) { return k.intValue < 10; }]).to.beTruthy();
        expect([dict all:^BOOL(NSNumber *k, id v) { return k.intValue > 3; }]).to.beFalsy();
        __block NSUInteger count = 0;
        expect([dict all:^BOOL(NSNumber *k, id v) {
            count++;
            expect(v).to.beKindOf([NSString class]);
            return YES;
        }]).to.beTruthy();
        expect(count).to.equal(dict.count);
    });

    it(@"-none:", ^{
        NSDictionary *dict = @{ @0: @"zero", @1: @"one", @2: @"two", @3: @"three", @4: @"four", @5: @"five" };
        expect([dict none:^BOOL(NSNumber *k, id v) { return k.intValue < 10; }]).to.beFalsy();
        expect([dict none:^BOOL(NSNumber *k, id v) { return k.intValue > 3; }]).to.beFalsy();
        expect([dict none:^BOOL(NSNumber *k, id v) { return k.intValue < 0; }]).to.beTruthy();
        __block NSUInteger count = 0;
        expect([dict none:^BOOL(NSNumber *k, id v) {
            count++;
            expect(v).to.beKindOf([NSString class]);
            return NO;
        }]).to.beTruthy();
        expect(count).to.equal(dict.count);
    });

    it(@"-each:", ^{
        NSDictionary *dict = @{ @0: @"zero", @1: @"one", @2: @"two", @3: @"three", @4: @"four", @5: @"five" };
        __block NSUInteger count = 0;
        __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [dict each:^(NSNumber *k, id v) {
            count++;
            expect(v).to.beKindOf([NSString class]);
            result[k] = v;
        }];
        expect(result).to.equal(dict);
        expect(count).to.equal(dict.count);
    });

    it(@"-map:", ^{
        NSDictionary *dict = @{ @0: @"zero", @1: @"one", @2: @"two", @3: @"three", @4: @"four", @5: @"five" };
        NSDictionary *result = [dict map:^NSNumber *(NSNumber *k, id v) {
            return @(k.intValue * k.intValue);
        }];
        expect(result).to.haveCountOf(dict.count);
        for (NSNumber *k in result) {
            expect(result[k]).to.equal(@(k.intValue * k.intValue));
        }

        result = [dict map:^id(NSNumber *k, id v) { return nil; }];
        expect(result).to.haveCountOf(dict.count);
        for (NSNumber *k in result) {
            expect(result[k]).to.equal([NSNull null]);
        }
    });

    it(@"-filter:", ^{
        NSDictionary *dict = @{ @0: @"zero", @1: @"one", @2: @"two", @3: @"three", @4: @"four", @5: @"five" };
        expect([dict filter:^BOOL(NSNumber *x, id v) { return NO; }]).to.beEmpty();
        expect([dict filter:^BOOL(NSNumber *x, id v) { return YES; }]).to.equal(dict);
    });

    it(@"-firstMatch:", ^{
        NSDictionary *dict = @{ @0: @"zero", @1: @"one", @2: @"two", @3: @"three", @4: @"four", @5: @"five" };
        expect([dict firstMatch:^BOOL(NSNumber *k, id v) { return [k isEqualToNumber:@1]; }]).to.equal(@"one");
    });
});

SpecEnd
