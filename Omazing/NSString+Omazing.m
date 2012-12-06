//
//  NSString+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 4/15/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import "NSData+Omazing.h"

#import "NSString+Omazing.h"

@implementation NSString (Omazing)

+ (BOOL)isNilOrEmpty:(NSString *)str
{
    return str == nil || str.length == 0;
}

+ (NSString *)uuid
{
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

- (NSArray *)arrayWithMatchedRegex:(NSString *)pattern
{
    NSError *err = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&err];
    if (regex == nil)
        return nil;

    NSArray *matches = [regex matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, self.length)];
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:matches.count];
    for (NSTextCheckingResult *match in matches) {
        NSString *matchedStr = [self substringWithRange:match.range];
        [results addObject:matchedStr];
    }

    return [results autorelease];
}

- (BOOL)isMatchRegex:(NSString *)pattern
{
    NSError *err = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&err];
    if (regex == nil)
        return NO;

    NSUInteger n = [regex numberOfMatchesInString:self
                                          options:0
                                            range:NSMakeRange(0, self.length)];
    return n > 0;
}

- (NSString *)md5
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    return [data md5];
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    return [data sha1];
}

- (NSString *)sha256
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    return [data sha256];
}

- (NSString *)sha512 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    return [data sha512];
}

- (BOOL)isEmail
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
