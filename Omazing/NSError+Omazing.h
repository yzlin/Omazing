//
//  NSError+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 4/28/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

extern NSString * const kOMZCommonCryptoErrorDomain;

@interface NSError (Omazing)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;
+ (NSError *)errorWithPOSIXCode:(int)code;
+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;

@end
