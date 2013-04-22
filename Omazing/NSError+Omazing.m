//
//  NSError+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 4/28/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import "NSError+Omazing.h"

NSString * const kOMZCommonCryptoErrorDomain = @"OMZCommonCryptoErrorDomain";

@implementation NSError (Omazing)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)desc
{
    NSDictionary *infoDict = @{NSLocalizedDescriptionKey: desc};

    return [[[NSError alloc] initWithDomain:domain
                                       code:code
                                   userInfo:infoDict] autorelease];
}

+ (NSError *)errorWithPOSIXCode:(int)code
{
    return [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:nil];
}

+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status
{
    NSString *description = nil;
    NSString *reason = nil;

    switch (status) {
        case kCCSuccess:
            description = NSLocalizedString(@"Success", @"Error description");
            break;

        case kCCParamError:
            description = NSLocalizedString(@"Parameter Error", @"Error description");
            reason = NSLocalizedString(@"Illegal parameter supplied to encryption/decryption algorithm", @"Error reason");
            break;

        case kCCBufferTooSmall:
            description = NSLocalizedString(@"Buffer Too Small", @"Error description");
            reason = NSLocalizedString(@"Insufficient buffer provided for specified operation", @"Error reason");
            break;

        case kCCMemoryFailure:
            description = NSLocalizedString(@"Memory Failure", @"Error description");
            reason = NSLocalizedString(@"Failed to allocate memory", @"Error reason");
            break;

        case kCCAlignmentError:
            description = NSLocalizedString(@"Alignment Error", @"Error description");
            reason = NSLocalizedString(@"Input size to encryption algorithm was not aligned correctly", @"Error reason");
            break;

        case kCCDecodeError:
            description = NSLocalizedString(@"Decode Error", @"Error description");
            reason = NSLocalizedString(@"Input data did not decode or decrypt correctly", @"Error reason");
            break;

        case kCCUnimplemented:
            description = NSLocalizedString(@"Unimplemented Function", @"Error description");
            reason = NSLocalizedString(@"Function not implemented for the current algorithm", @"Error reason");
            break;

        default:
            description = NSLocalizedString(@"Unknown Error", @"Error description");
            break;
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[NSLocalizedDescriptionKey] = description;

    if (reason) userInfo[NSLocalizedFailureReasonErrorKey] = reason;

    NSError * result = [NSError errorWithDomain:kOMZCommonCryptoErrorDomain
                                           code:status
                                       userInfo:userInfo];
    [userInfo release];

    return result;
}

@end
