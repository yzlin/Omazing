//
//  NSBundle+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 6/29/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <objc/runtime.h>

#import "Omazing.h"

#import "NSBundle+Omazing.h"

@implementation NSBundle (Omazing)

static char brandAssociatedKey;

+ (void)load
{
    [Omazing swizzleMethod:@selector(localizedStringForKey:value:table:)
                      with:@selector(_localizedStringForKey:value:table:)
                        of:self];
}

#pragma mark Properties

- (NSString *)brand
{
    return (NSString *)objc_getAssociatedObject(self, &brandAssociatedKey);
}

- (void)setBrand:(NSString *)brand
{
    objc_setAssociatedObject(self, &brandAssociatedKey, brand, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Swizzled Methods

- (NSString *)_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if ([tableName length] == 0)
        tableName = @"Localizable";

    NSString *localizedString = nil;

    // Match Rules:
    //   Get current language ID from [NSLocale preferredLanguages]: first object indicates current language ID
    //     1) Search in specified brand
    //     2) Search default language ID (non-branded)
    //   If no one matched, use System Default

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *languageID = [[NSLocale preferredLanguages] objectAtIndex:0];
    BOOL isDirectory;

    if ([self.brand length] > 0) {
        NSString *brandLanguagePath = [[self resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"brand/%@/%@.%@.strings", self.brand, tableName, languageID]];
        if ([fileMgr fileExistsAtPath:brandLanguagePath isDirectory:&isDirectory] && !isDirectory) {
            NSDictionary *table = [NSDictionary dictionaryWithContentsOfFile:brandLanguagePath];
            localizedString = [table objectForKey:key];
        }
    }

    NSString *defaultLanguagePath = [[self resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"brand/_default/%@.%@.strings", tableName, languageID]];
    if (!localizedString && [fileMgr fileExistsAtPath:defaultLanguagePath isDirectory:&isDirectory] && !isDirectory) {
        NSDictionary *table = [NSDictionary dictionaryWithContentsOfFile:defaultLanguagePath];
        localizedString = [table objectForKey:key];
    }

    if (!localizedString)
        localizedString = [self _localizedStringForKey:key value:value table:tableName];

    if (localizedString)
        return localizedString;
    else
        return [value length] > 0 ? value : key;
}

@end
