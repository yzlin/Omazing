// NSString+OmazingTests.m
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

SpecBegin(NSString)

describe(@"NSString", ^{
    context(@"when string is nil or empty", ^{
        it(@"should return true while checking null or empty strings", ^{
            expect([NSString isNilOrEmpty:nil]).to.beTruthy();
            expect([NSString isNilOrEmpty:@""]).to.beTruthy();
        });
    });

    context(@"when string is 'The quick brown fox jumps over the lazy dog.'", ^{
        NSString * const str = @"The quick brown fox jumps over the lazy dog.";

        it(@"should return false while checking it's empty or null", ^{
            expect([NSString isNilOrEmpty:str]).to.beFalsy();
            expect([NSString isNilOrEmpty:str]).to.beFalsy();
        });

        it(@"should have MD5 value of e4d909c290d0fb1ca068ffaddf22cbd0", ^{
            expect([str md5]).to.equal(@"e4d909c290d0fb1ca068ffaddf22cbd0");
        });

        it(@"should have SHA-1 value of 408d94384216f890ff7a0c3528e8bed1e0b01621", ^{
            expect([str sha1]).to.equal(@"408d94384216f890ff7a0c3528e8bed1e0b01621");
        });

        it(@"should have SHA-256 value of ef537f25c895bfa782526529a9b63d97aa631564d5d789c2b765448c8635fb6c", ^{
            expect([str sha256]).to.equal(@"ef537f25c895bfa782526529a9b63d97aa631564d5d789c2b765448c8635fb6c");
        });

        it(@"should have SHA-512 value of 91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bbc6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed", ^{
            expect([str sha512]).to.equal(@"91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bbc6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed");
        });
    });

    context(@"when string is \"中文字嘛A通\"", ^{
        NSString * const str = @"中文字嘛A通";

        it(@"should return false while checking it's empty or null", ^{
            expect([NSString isNilOrEmpty:str]).to.beFalsy();
            expect([NSString isNilOrEmpty:str]).to.beFalsy();
        });

        it(@"should have MD5 value of 83d05576facbb56237c04636b437a5fc", ^{
            expect([str md5]).to.equal(@"83d05576facbb56237c04636b437a5fc");
        });

        it(@"should have SHA-1 value of d958c704c589f6690b51242607e5e3c348cd41fb", ^{
            expect([str sha1]).to.equal(@"d958c704c589f6690b51242607e5e3c348cd41fb");
        });

        it(@"should have SHA-256 value of 75560a813ff2f7683acf8062bea1aca267171c4b0a1ae7d5e6149eadb0a7a3c3", ^{
            expect([str sha256]).to.equal(@"75560a813ff2f7683acf8062bea1aca267171c4b0a1ae7d5e6149eadb0a7a3c3");
        });

        it(@"should have SHA-512 value of 3afc468ec750c85ea5126082c28a7415e097fb8c17abbef2bc6fe0712385a69200f1f8a065028f54ee41161b816b5d2300a8059e96522f61ec82d4a05be4f5d0", ^{
            expect([str sha512]).to.equal(@"3afc468ec750c85ea5126082c28a7415e097fb8c17abbef2bc6fe0712385a69200f1f8a065028f54ee41161b816b5d2300a8059e96522f61ec82d4a05be4f5d0");
        });
    });

    context(@"when string is an URL http://www.example.com", ^{
        NSString * const str = @"http://www.example.com";

        it(@"should return false while checking it's empty or null", ^{
            expect([NSString isNilOrEmpty:str]).to.beFalsy();
            expect([NSString isNilOrEmpty:str]).to.beFalsy();
        });

        it(@"should have only one matched string with regex /https?/", ^{
            expect([str arrayWithMatchedRegex:@"https?"]).to.equal(@[ @"http" ]);
        });

        it(@"should have matched strings 'http', 'www', 'example', 'com' with regex /\\w+/", ^{
            expect([str arrayWithMatchedRegex:@"\\w+"]).to.equal((@[ @"http", @"www", @"example", @"com" ]));
        });

        it(@"should have matched strings 'http', 'example' with regex /(https?|(ex\\w+))/", ^{
            expect([str arrayWithMatchedRegex:@"(https?|ex\\w+)"]).to.equal((@[ @"http", @"example" ]));
        });

        it(@"should have no matched string with regex /https/", ^{
            expect([str arrayWithMatchedRegex:@"https"]).to.equal(@[]);
        });
    });

    context(@"email validation", ^{
        it(@"should return false while checking it's empty or null", ^{
            NSString *email = @"";
            expect([email isEmail]).to.beFalsy();
            email = nil;
            expect([email isEmail]).to.beFalsy();
        });

        it(@"invalid emails", ^{
            expect([@"test" isEmail]).to.beFalsy();
            expect([@"test@test" isEmail]).to.beFalsy();
            expect([@"@test" isEmail]).to.beFalsy();
            expect([@"a#asdf@test.com" isEmail]).to.beFalsy();
            expect([@"test@test.local" isEmail]).to.beFalsy();
            expect([@"test12+test@test.local" isEmail]).to.beFalsy();
            expect([@"test12.test@test.local" isEmail]).to.beFalsy();
        });

        it(@"valid emails", ^{
            expect([@"test@a.b.c.com" isEmail]).to.beTruthy();
            expect([@"test12+test@test.com" isEmail]).to.beTruthy();
            expect([@"test12.test@test.com" isEmail]).to.beTruthy();
            expect([@"test123.test@example.com" isEmail]).to.beTruthy();
        });
    });

    context(@"path operations", ^{
        it(@"subpath validation", ^{
            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"/path"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"/path//"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"//path"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"/"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"/path//to/"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"/pa"]).to.beFalsy();

            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"/path/to/subpath/a.txt"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt" isSubpathOfPath:@"/path/to/subpath/a.txt/"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt/" isSubpathOfPath:@"/path/to/subpath/a.txt"]).to.beTruthy();
            expect([@"/path/to/subpath/a.txt/" isSubpathOfPath:@"/path/to/subpath/a.txt/"]).to.beTruthy();
        });
    });

    context(@"string producing", ^{
        it(@"should return trimmed strings", ^{
            expect(@"\n   this is \n \t a sentence.".trimmedString).to.equal(@"this is \n \t a sentence.");
            expect(@"      this is \t a sentence. \n".trimmedString).to.equal(@"this is \t a sentence.");
            expect(@"\n   this is \n \t a sentence.   \t".trimmedString).to.equal(@"this is \n \t a sentence.");
        });
    });
});

SpecEnd
