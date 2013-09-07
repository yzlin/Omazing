// NSData+OmazingTests.m
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

SpecBegin(NSData)

describe(@"NSData", ^{
    it(@"- hex", ^{
        uint8_t dataBytes1[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        NSData *data = [NSData dataWithBytes:dataBytes1 length:sizeof(dataBytes1)];
        expect(data.omz_hex.length).to.equal(sizeof(dataBytes1) * 2);
        expect(data.omz_hex).to.equal(@"00000000000000000000");

        uint8_t dataBytes2[10] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
        data = [NSData dataWithBytes:dataBytes2 length:sizeof(dataBytes2)];
        expect(data.omz_hex.length).to.equal(sizeof(dataBytes2) * 2);
        expect(data.omz_hex).to.equal(@"01010101010101010101");

        uint8_t dataBytes3[10] = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255};
        data = [NSData dataWithBytes:dataBytes3 length:sizeof(dataBytes3)];
        expect(data.omz_hex.length).to.equal(sizeof(dataBytes3) * 2);
        expect(data.omz_hex).to.equal(@"ffffffffffffffffffff");
    });
});

SpecEnd
