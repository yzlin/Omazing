// NSURL+OmazingTests.m
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
