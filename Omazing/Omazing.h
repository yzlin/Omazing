// Omazing.h
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

#import <TargetConditionals.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "NSArray+Omazing.h"
#import "NSBundle+Omazing.h"
#import "NSData+Omazing.h"
#import "NSDictionary+Omazing.h"
#import "NSError+Omazing.h"
#import "NSObject+Omazing.h"
#import "NSSet+Omazing.h"
#import "NSString+Omazing.h"
#import "NSThread+Omazing.h"
#import "NSURL+Omazing.h"
#import "NSTimer+Omazing.h"

@interface Omazing : NSObject

#pragma mark - Hash

+ (NSString *)omz_md5FromFile:(NSString *)filePath;
+ (NSString *)omz_sha1FromFile:(NSString *)filePath;
+ (NSString *)omz_sha256FromFile:(NSString *)filePath;
+ (NSString *)omz_sha512FromFile:(NSString *)filePath;

#pragma mark - Runtime method swizzling

// inspired from ConciseKit
+ (BOOL)omz_swizzleMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass;
+ (BOOL)omz_swizzleMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass;
+ (BOOL)omz_swizzleClassMethod:(SEL)origSelector with:(SEL)anotherSelector of:(Class)klass;
+ (BOOL)omz_swizzleClassMethod:(SEL)origSelector of:(Class)origKlass with:(SEL)anotherSelector of:(Class)anotherKlass;

#if !TARGET_OS_IPHONE
+ (NSSet *)omz_pidsAccessingPath:(NSString *)path;
#endif

#pragma mark - Utils

#define omz_safe(OBJ) ((NSNull *)(OBJ) == [NSNull null] ? nil : (OBJ))

@end
