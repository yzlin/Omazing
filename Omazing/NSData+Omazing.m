//
//  NSData+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 10/5/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSData+Omazing.h"

@implementation NSData (Omazing)

- (NSString *)md5
{
    uint8_t digest[CC_MD5_DIGEST_LENGTH];

    NSNumber *len = [NSNumber numberWithUnsignedInteger:self.length];
    CC_MD5(self.bytes, [len unsignedIntValue], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)sha1
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    NSNumber *len = [NSNumber numberWithUnsignedInteger:self.length];
    CC_SHA1(self.bytes, [len unsignedIntValue], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)sha256
{
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    NSNumber *len = [NSNumber numberWithUnsignedInteger:self.length];
    CC_SHA256(self.bytes, [len unsignedIntValue], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)sha512 {
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];

    NSNumber *len = [NSNumber numberWithUnsignedInteger:self.length];
    CC_SHA512(self.bytes, [len unsignedIntValue], digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

@end
