// NSError+Omazing.m
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

#import "NSError+Omazing.h"

NSString * const kOMZCommonCryptoErrorDomain = @"OMZCommonCryptoErrorDomain";

@implementation NSError (Omazing)

+ (NSError *)omz_errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)desc
{
    NSDictionary *infoDict = @{ NSLocalizedDescriptionKey: desc };

    return [[NSError alloc] initWithDomain:domain
                                       code:code
                                   userInfo:infoDict];
}

+ (NSError *)omz_errorWithPOSIXCode:(int)code
{
    return [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:nil];
}

+ (NSError *)omz_errorWithCCCryptorStatus:(CCCryptorStatus)status
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

    return result;
}

@end
