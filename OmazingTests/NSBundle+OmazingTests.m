// NSBundle+OmazingTests.m
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

SpecBegin(NSbundle)

describe(@"NSBundle", ^{
    beforeEach(^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        bundle.brand = nil;
    });

    it(@"can localize strings by default localization engine", ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        NSLog(@"Bundle Path: %@", bundle.bundlePath);
        expect([bundle localizedStringForKey:@"Hello" value:@"" table:nil]).to.equal(@"#orig#en#Hello#");
        expect([bundle localizedStringForKey:@"NOT EXISTS" value:@"" table:nil]).to.equal(@"NOT EXISTS");
        expect(bundle.brand).to.beNil();
    });

    it(@"should display branded localization strings when brand is set", ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        bundle.brand = @"fakebrand";
        expect([bundle localizedStringForKey:@"Hello" value:@"" table:nil]).to.equal(@"#fakebrand#en#Hello#");
        expect([bundle localizedStringForKey:@"NOT EXISTS" value:@"" table:nil]).to.equal(@"NOT EXISTS");
        expect(bundle.brand).toNot.beNil();
    });

    it(@"should display default branded localization strings when brand is set but cannot find the key in specified brand", ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        bundle.brand = @"fakebrand";
        expect([bundle localizedStringForKey:@"World" value:@"" table:nil]).to.equal(@"#_default#en#World#");
        expect(bundle.brand).toNot.beNil();
    });

    it(@"can get localize info by default localization engine", ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        expect(bundle.localizedInfoDictionary.count).to.equal(1);
        expect([bundle.localizedInfoDictionary objectForKey:@"CFBundleDisplayName"]).to.equal(@"#_default#en#CFBundleDisplayName#");
        expect([bundle.localizedInfoDictionary objectForKey:@"NOT EXISTS"]).to.beNil();
        expect(bundle.brand).to.beNil();
    });

    it(@"should display branded localization info when brand is set", ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        bundle.brand = @"fakebrand";
        expect([bundle.localizedInfoDictionary objectForKey:@"CFBundleName"]).to.equal(@"#fakebrand#en#CFBundleName#");
        expect([bundle.localizedInfoDictionary objectForKey:@"NOT EXISTS"]).to.beNil();
        expect(bundle.brand).toNot.beNil();
    });
});

SpecEnd
