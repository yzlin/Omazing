//
//  NSString+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 4/15/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Omazing)

+ (BOOL)isNilOrEmpty:(NSString *)str;
+ (NSString *)uuid;

- (NSArray *)arrayWithMatchedRegex:(NSString *)pattern;
- (BOOL)isMatchRegex:(NSString *)pattern;

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)sha512;

@end
