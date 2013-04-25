// NSString+Omazing.m
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

#import "NSData+Omazing.h"

#import "NSString+Omazing.h"

@implementation NSString (Omazing)

+ (BOOL)isNilOrEmpty:(NSString *)str
{
    return (str.length == 0);
}

+ (NSString *)uuid
{
    return [NSProcessInfo processInfo].globallyUniqueString;
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

    return results;
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

- (BOOL)isSubpathOfPath:(NSString *)path
{
    NSParameterAssert(path);
    NSString *selfPath = [self stringByStandardizingPath];
    if (![selfPath isEqualToString:@"/"])
        selfPath = [selfPath stringByAppendingString:@"/"];

    NSString *comparedPath = [path stringByStandardizingPath];
    if (![comparedPath hasSuffix:@"/"])
        comparedPath = [comparedPath stringByAppendingString:@"/"];

    NSRange result = [selfPath rangeOfString:comparedPath options:NSAnchoredSearch | NSCaseInsensitiveSearch];
    return (result.location == 0);
}

- (NSString *)trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
