//
//  NSData+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 10/5/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (Omazing)

#pragma mark - Hash

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)sha512;

#pragma mark - Symmetric Encryption

- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                  error:(CCCryptorStatus *) error;
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error;
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                     iv:(NSData *)iv
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error;

- (NSData *)dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                  error:(CCCryptorStatus *)error;
- (NSData *)dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error;
- (NSData *)dataDecryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(NSData *)key
                                     iv:(NSData *)iv
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error;

- (NSData *)dataAES256EncryptedUsingKey:(NSData *)key error:(NSError **)error;
- (NSData *)dataAES256DecryptedUsingKey:(NSData *)key error:(NSError **)error;

@end
