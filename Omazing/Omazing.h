//
//  Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 4/13/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "NSArray+Omazing.h"
#import "NSBundle+Omazing.h"
#import "NSError+Omazing.h"
#import "NSString+Omazing.h"
#import "NSURL+Omazing.h"

@interface Omazing : NSObject

+ (NSString *)md5FromFile:(NSString *)filePath;
+ (NSString *)sha1FromFile:(NSString *)filePath;
+ (NSString *)sha256FromFile:(NSString *)filePath;
+ (NSString *)sha512FromFile:(NSString *)filePath;

// inspired from ConciseKit
+ (BOOL)swizzleMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass;
+ (BOOL)swizzleMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass;
+ (BOOL)swizzleClassMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass;
+ (BOOL)swizzleClassMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass;

@end
