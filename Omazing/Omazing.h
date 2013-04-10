//
//  Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 4/13/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <TargetConditionals.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "NSArray+Omazing.h"
#import "NSBundle+Omazing.h"
#import "NSData+Omazing.h"
#import "NSError+Omazing.h"
#import "NSString+Omazing.h"
#import "NSThread+Omazing.h"
#import "NSURL+Omazing.h"
#import "NSTimer+Omazing.h"

@interface Omazing : NSObject

#pragma mark - Hash

+ (NSString *)md5FromFile:(NSString *)filePath;
+ (NSString *)sha1FromFile:(NSString *)filePath;
+ (NSString *)sha256FromFile:(NSString *)filePath;
+ (NSString *)sha512FromFile:(NSString *)filePath;

#pragma mark - Runtime method swizzling

// inspired from ConciseKit
+ (BOOL)swizzleMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass;
+ (BOOL)swizzleMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass;
+ (BOOL)swizzleClassMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass;
+ (BOOL)swizzleClassMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass;

#if !TARGET_OS_IPHONE
+ (NSSet *)pidsAccessingPath:(NSString *)path;
#endif

#pragma mark - Utils

#define $safe(OBJ) ((NSNull *)(OBJ) == [NSNull null] ? nil : (OBJ))

@end
