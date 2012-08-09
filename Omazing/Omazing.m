//
//  Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 4/13/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "Omazing.h"

@implementation Omazing

+ (NSString *)md5FromFile:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle)
        return nil;

    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);

    while (YES) {
        NSData *data = [handle readDataOfLength:1024];
        if (data.length == 0)
            break;
        NSNumber *len = [NSNumber numberWithUnsignedInteger:data.length];
        CC_MD5_Update(&md5, data.bytes, [len unsignedIntValue]);
    }

    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)sha1FromFile:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle)
        return nil;

    CC_SHA1_CTX sha1;
    CC_SHA1_Init(&sha1);

    while (YES) {
        NSData *data = [handle readDataOfLength:1024];
        if (data.length == 0)
            break;
        NSNumber *len = [NSNumber numberWithUnsignedInteger:data.length];
        CC_SHA1_Update(&sha1, data.bytes, [len unsignedIntValue]);
    }

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha1);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)sha256FromFile:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle)
        return nil;

    CC_SHA256_CTX sha256;
    CC_SHA256_Init(&sha256);

    while (YES) {
        NSData *data = [handle readDataOfLength:1024];
        if (data.length == 0)
            break;
        NSNumber *len = [NSNumber numberWithUnsignedInteger:data.length];
        CC_SHA256_Update(&sha256, data.bytes, [len unsignedIntValue]);
    }

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(digest, &sha256);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)sha512FromFile:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle)
        return nil;

    CC_SHA512_CTX sha512;
    CC_SHA512_Init(&sha512);

    while (YES) {
        NSData *data = [handle readDataOfLength:1024];
        if (data.length == 0)
            break;
        NSNumber *len = [NSNumber numberWithUnsignedInteger:data.length];
        CC_SHA512_Update(&sha512, data.bytes, [len unsignedIntValue]);
    }

    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(digest, &sha512);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

#pragma mark Method Swizzling

+ (BOOL)swizzleMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass
{
    return [self swizzleMethod:origSelector of:klass with:anotherSelector of:klass];
}

+ (BOOL)swizzleMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass
{
    Method origMethod = class_getInstanceMethod(origKlass, origSelector);
    Method anotherMethod = class_getInstanceMethod(anotherKlass, anotherSelector);
    if (!origMethod || !anotherMethod)
        return NO;
    IMP originalMethodImp = class_getMethodImplementation(origKlass, origSelector);
    IMP anotherMethodImp = class_getMethodImplementation(anotherKlass, anotherSelector);
    if (class_addMethod(origKlass, origSelector, originalMethodImp, method_getTypeEncoding(origMethod)))
        origMethod = class_getInstanceMethod(origKlass, origSelector);
    if (class_addMethod(anotherKlass, anotherSelector, anotherMethodImp, method_getTypeEncoding(anotherMethod)))
        anotherMethod = class_getInstanceMethod(anotherKlass, anotherSelector);
    method_exchangeImplementations(origMethod, anotherMethod);
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass
{
    return [self swizzleClassMethod:origSelector of:klass with:anotherSelector of:klass];
}

+ (BOOL)swizzleClassMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass
{
    Method origMethod = class_getClassMethod(origKlass, origSelector);
    Method anotherMethod = class_getClassMethod(anotherKlass, anotherSelector);
    if (!origMethod || !anotherMethod)
        return NO;
    Class metaClass = objc_getMetaClass(class_getName(origKlass));
    Class anotherMetaClass = objc_getMetaClass(class_getName(anotherKlass));
    IMP originalMethodImp = class_getMethodImplementation(metaClass, origSelector);
    IMP anotherMethodImp = class_getMethodImplementation(anotherMetaClass, anotherSelector);
    if (class_addMethod(metaClass, origSelector, originalMethodImp, method_getTypeEncoding(origMethod)))
        origMethod = class_getClassMethod(origKlass, origSelector);
    if (class_addMethod(anotherMetaClass, anotherSelector, anotherMethodImp,  method_getTypeEncoding(anotherMethod)))
        anotherMethod = class_getClassMethod(anotherKlass, anotherSelector);
    method_exchangeImplementations(origMethod, anotherMethod);
    return YES;
}

@end
