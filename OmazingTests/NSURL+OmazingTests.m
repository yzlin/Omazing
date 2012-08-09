//
//  NSString+OmazingTests.m
//  Omazing
//
//  Created by Ethan Lin on 8/9/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "Omazing.h"

SpecBegin(NSURL)

describe(@"NSURL", ^{
    it(@"cannot be created by percent escaping nil string", ^{
        expect([NSURL URLByAddingPercentEscapesWithString:nil]).to.beNil();
    });

    it(@"should create an NSURL object with the same URL as the original after being percent escapted", ^{
        NSString * const str = @"http://www.google.com";
        expect([NSURL URLByAddingPercentEscapesWithString:str]).to.equal([NSURL URLWithString:str]);
    });

    it(@"should create an escapted NSURL object", ^{
        NSString * const str = @"http://www.google.com/?test= abc 123";
        expect([NSURL URLByAddingPercentEscapesWithString:str]).to.equal([NSURL URLWithString:@"http://www.google.com/?test=%20abc%20123"]);
    });
});

SpecEnd
