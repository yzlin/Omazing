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
});

SpecEnd
