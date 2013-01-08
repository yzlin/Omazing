//
//  OmazingTests.m
//  Omazing
//
//  Created by Ethan Lin on 12/13/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//


#import <Specta.h>
#define EXP_SHORTHAND
#import <Expecta.h>

#import "Omazing.h"

SpecBegin(Omazing)

describe(@"Utils", ^{

    it(@"should support getting safe objects", ^{
        expect($safe([NSNull null])).to.equal(nil);
        expect($safe(nil)).to.equal(nil);
        expect($safe(@"string")).to.equal(@"string");
        expect($safe(@YES)).to.equal(@YES);
        expect($safe(@1)).to.equal(@1);
        expect($safe(@[@1])).to.equal(@[@1]);
        expect($safe(@{@"key": @"value"})).to.equal(@{@"key": @"value"});
    });

});

SpecEnd
