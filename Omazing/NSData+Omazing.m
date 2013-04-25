// NSData+Omazing.m
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

#import "NSError+Omazing.h"

#import "NSData+Omazing.h"

@implementation NSData (Omazing)

#pragma mark - Hash

- (NSString *)md5
{
    uint8_t digest[CC_MD5_DIGEST_LENGTH];

    NSNumber *len = @(self.length);
    CC_MD5(self.bytes, len.unsignedIntValue, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)sha1
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    NSNumber *len = @(self.length);
    CC_SHA1(self.bytes, len.unsignedIntValue, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)sha256
{
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    NSNumber *len = @(self.length);
    CC_SHA256(self.bytes, len.unsignedIntValue, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)sha512 {
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];

    NSNumber *len = @(self.length);
    CC_SHA512(self.bytes, len.unsignedIntValue, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

#pragma mark - Symmetric Encryption


static void FixKeyLengths(CCAlgorithm algorithm, NSMutableData *keyData, NSMutableData *ivData)
{
    NSUInteger keyLength = keyData.length;
    switch (algorithm) {
        case kCCAlgorithmAES128:
            if (keyLength < 16) {
                keyData.length = 16;
            } else if (keyLength < 24) {
                keyData.length = 24;
            } else {
                keyData.length = 32;
            }

            break;

        case kCCAlgorithmDES:
            keyData.length = 8;
            break;

        case kCCAlgorithm3DES:
            keyData.length = 24;
            break;

        case kCCAlgorithmCAST:
            if (keyLength < 5) {
                keyData.length = 5;
            } else if (keyLength > 16) {
                keyData.length = 16;
            }

            break;

        case kCCAlgorithmRC4:
            if (keyLength > 512)
                keyData.length = 512;
            break;

        default:
            break;
    }

    ivData.length = keyData.length;
}

- (NSData *)_runCryptor:(CCCryptorRef)cryptor result:(CCCryptorStatus *)status
{
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)self.length, true);
    void * buf = malloc(bufsize);
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate(cryptor, self.bytes, (size_t)self.length,
                              buf, bufsize, &bufused);
    if (*status != kCCSuccess) {
        free(buf);
        return nil;
    }

    bytesTotal += bufused;

    // From Brent Royal-Gordon (Twitter: architechies):
    //  Need to update buf ptr past used bytes when calling CCCryptorFinal()
    *status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    if (*status != kCCSuccess) {
        free(buf);
        return nil;
    }

    bytesTotal += bufused;

    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                  error:(CCCryptorStatus *)error
{
    return [self dataEncryptedUsingAlgorithm:algorithm
                                         key:key
                                          iv:nil
                                     options:0
                                       error:error];
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    return [self dataEncryptedUsingAlgorithm:algorithm
                                         key:key
                                          iv:nil
                                     options:options
                                       error:error];
}

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                     iv:(NSData *)iv
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;

    NSMutableData *keyData = (NSMutableData *)[key mutableCopy];
    NSMutableData *ivData = (NSMutableData *)[iv mutableCopy];

    // ensure correct lengths for key and iv data, based on algorithms
    FixKeyLengths(algorithm, keyData, ivData);

    status = CCCryptorCreate(kCCEncrypt, algorithm, options,
                             keyData.bytes, keyData.length, ivData.bytes,
                             &cryptor);

    if (status != kCCSuccess) {
        if (error) *error = status;
        return nil;
    }

    NSData *result = [self _runCryptor:cryptor result:&status];
    if (!result && error) *error = status;

    CCCryptorRelease(cryptor);

    return result;
}

- (NSData *)dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                  error:(CCCryptorStatus *)error
{
    return [self dataDecryptedUsingAlgorithm:algorithm
                                         key:key
                                          iv:nil
                                     options:0
                                       error:error];
}

- (NSData *)dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    return [self dataDecryptedUsingAlgorithm:algorithm
                                         key:key
                                          iv:nil
                                     options:options
                                       error:error];
}

- (NSData *)dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                     iv:(NSData *)iv
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error
{
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;

    NSMutableData *keyData= (NSMutableData *)[key mutableCopy];
    NSMutableData *ivData = (NSMutableData *)[iv mutableCopy];

    // ensure correct lengths for key and iv data, based on algorithms
    FixKeyLengths(algorithm, keyData, ivData);

    status = CCCryptorCreate(kCCDecrypt, algorithm, options,
                             keyData.bytes, keyData.length, ivData.bytes,
                             &cryptor);

    if (status != kCCSuccess) {
        if (error) *error = status;
        return nil;
    }

    NSData *result = [self _runCryptor:cryptor result:&status];
    if (!result && error) *error = status;

    CCCryptorRelease(cryptor);

    return result;
}

#pragma AES

- (NSData *)dataAES256EncryptedUsingKey:(NSData *)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                   key:key
                                               options:kCCOptionPKCS7Padding
                                                 error:&status];

    if (result) return result;

    if (error) *error = [NSError errorWithCCCryptorStatus:status];

    return nil;
}

- (NSData *)dataAES256DecryptedUsingKey:(NSData *)key error:(NSError **)error
{
    CCCryptorStatus status = kCCSuccess;
    NSData *result = [self dataDecryptedUsingAlgorithm:kCCAlgorithmAES128
                                                   key:key
                                               options:kCCOptionPKCS7Padding
                                                 error:&status];

    if (result) return result;

    if (error) *error = [NSError errorWithCCCryptorStatus:status];

    return nil;
}

@end
