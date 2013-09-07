// NSBundle+Omazing.m
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

#import <objc/runtime.h>

#import "Omazing.h"

#import "NSBundle+Omazing.h"

@implementation NSBundle (Omazing)

static char brandAssociatedKey;

+ (void)load
{
    [Omazing omz_swizzleMethod:@selector(localizedInfoDictionary)
                          with:@selector(__localizedInfoDictionary)
                            of:self];
    [Omazing omz_swizzleMethod:@selector(localizedStringForKey:value:table:)
                          with:@selector(__localizedStringForKey:value:table:)
                            of:self];
}

#pragma mark Properties

- (NSString *)omz_brand
{
    return (NSString *)objc_getAssociatedObject(self, &brandAssociatedKey);
}

- (void)setOmz_brand:(NSString *)brand
{
    objc_setAssociatedObject(self, &brandAssociatedKey, brand, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Swizzled Methods

- (NSDictionary *)__localizedInfoDictionary
{
    // Match Rules:
    //   Get current language ID from [NSLocale preferredLanguages]: first object indicates current language ID
    //     1) Search in specified brand
    //     2) Search default language ID (non-branded)
    //   If no one matched, use System Default

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *languageID = [NSLocale preferredLanguages][0];
    BOOL isDirectory;

    NSMutableDictionary *table = [NSMutableDictionary dictionaryWithDictionary:self.__localizedInfoDictionary];

    NSString *defaultLanguagePath = [[self resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"brand/_default/InfoPlist.%@.strings", languageID]];
    if ([fileMgr fileExistsAtPath:defaultLanguagePath isDirectory:&isDirectory] && !isDirectory) {
        [table addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:defaultLanguagePath]];
    }

    if (self.omz_brand.length > 0) {
        NSString *brandLanguagePath = [self.resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"brand/%@/InfoPlist.%@.strings", self.omz_brand, languageID]];
        if ([fileMgr fileExistsAtPath:brandLanguagePath isDirectory:&isDirectory] && !isDirectory) {
            [table addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:brandLanguagePath]];
        }
    }

    return table;
}

- (NSString *)__localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if (tableName.length == 0)
        tableName = @"Localizable";

    NSString *localizedString = nil;

    // Match Rules:
    //   Get current language ID from [NSLocale preferredLanguages]: first object indicates current language ID
    //     1) Search in specified brand
    //     2) Search default language ID (non-branded)
    //   If no one matched, use System Default

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *languageID = [NSLocale preferredLanguages][0];
    BOOL isDirectory;

    if (self.omz_brand.length > 0) {
        NSString *brandLanguagePath = [[self resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"brand/%@/%@.%@.strings", self.omz_brand, tableName, languageID]];
        if ([fileMgr fileExistsAtPath:brandLanguagePath isDirectory:&isDirectory] && !isDirectory) {
            NSDictionary *table = [NSDictionary dictionaryWithContentsOfFile:brandLanguagePath];
            localizedString = table[key];
        }
    }

    NSString *defaultLanguagePath = [[self resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"brand/_default/%@.%@.strings", tableName, languageID]];
    if (!localizedString && [fileMgr fileExistsAtPath:defaultLanguagePath isDirectory:&isDirectory] && !isDirectory) {
        NSDictionary *table = [NSDictionary dictionaryWithContentsOfFile:defaultLanguagePath];
        localizedString = table[key];
    }

    if (!localizedString)
        localizedString = [self __localizedStringForKey:key value:value table:tableName];

    if (localizedString)
        return localizedString;
    else
        return value.length > 0 ? value : key;
}

@end
