//
//  NSBundle+OmazingTests.m
//  Omazing
//
//  Created by Ethan Lin on 8/9/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

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
