// Omazing.m
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

#import <CommonCrypto/CommonDigest.h>

#if !TARGET_OS_IPHONE
#import <libproc.h>
#endif

#import "Omazing.h"

@implementation Omazing

#pragma mark - Hash

+ (NSString *)omz_md5FromFile:(NSString *)filePath
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
        NSNumber *len = @(data.length);
        CC_MD5_Update(&md5, data.bytes, len.unsignedIntValue);
    }

    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)omz_sha1FromFile:(NSString *)filePath
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
        NSNumber *len = @(data.length);
        CC_SHA1_Update(&sha1, data.bytes, len.unsignedIntValue);
    }

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha1);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)omz_sha256FromFile:(NSString *)filePath
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
        NSNumber *len = @(data.length);
        CC_SHA256_Update(&sha256, data.bytes, len.unsignedIntValue);
    }

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(digest, &sha256);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

+ (NSString *)omz_sha512FromFile:(NSString *)filePath
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
        NSNumber *len = @(data.length);
        CC_SHA512_Update(&sha512, data.bytes, len.unsignedIntValue);
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

+ (BOOL)omz_swizzleMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass
{
    return [self omz_swizzleMethod:origSelector of:klass with:anotherSelector of:klass];
}

+ (BOOL)omz_swizzleMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass
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

+ (BOOL)omz_swizzleClassMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass
{
    return [self omz_swizzleClassMethod:origSelector of:klass with:anotherSelector of:klass];
}

+ (BOOL)omz_swizzleClassMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass
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

#pragma mark - File Info

#if !TARGET_OS_IPHONE

+ (NSSet *)omz_pidsAccessingPath:(NSString *)path
{
    NSParameterAssert(path.length > 0);

    NSMutableSet *result = nil;
    pid_t *pids = NULL;
    const char *pathFileSystemRepresentation = [path stringByStandardizingPath].UTF8String;

    int listpidspathResult = proc_listpidspath(PROC_ALL_PIDS,
                                               0,
                                               pathFileSystemRepresentation,
                                               PROC_LISTPIDSPATH_EXCLUDE_EVTONLY,
                                               NULL,
                                               0);

    if (listpidspathResult < 0) goto cleanup;

    int pidsSize = (listpidspathResult ? listpidspathResult : 1);
    pids = malloc(pidsSize);

    if (!pids) goto cleanup;

    listpidspathResult = proc_listpidspath(PROC_ALL_PIDS,
                                           0,
                                           pathFileSystemRepresentation,
                                           PROC_LISTPIDSPATH_EXCLUDE_EVTONLY,
                                           pids,
                                           pidsSize);

    if (listpidspathResult < 0) goto cleanup;

    NSUInteger pidsCount = listpidspathResult / sizeof(*pids);
    result = [NSMutableSet set];

    for (int i = 0; i < pidsCount; i++)
        [result addObject:@(pids[i])];

cleanup:
    if (pids) {
        free(pids);
        pids = NULL;
    }

    return result;
}

#endif

@end
