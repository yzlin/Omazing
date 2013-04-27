// NSSet+Omazing.m
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

#import "NSSet+Omazing.h"

@implementation NSSet (Omazing)

- (BOOL)any:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    return [self firstMatch:block] != nil;
}

- (BOOL)all:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    __block BOOL result = YES;

    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (!block(obj)) {
            result = NO;
            *stop = YES;
        }
    }];

    return result;
}

- (BOOL)none:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    return [self firstMatch:block] == nil;
}

- (void)each:(void (^)(id))block
{
    NSParameterAssert(block != nil);

    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
}

- (NSSet *)map:(id (^)(id))block
{
    NSParameterAssert(block != nil);

    __block NSMutableSet *result = [NSMutableSet setWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        id value = block(obj);
        [result addObject:(value ? value : [NSNull null])];
    }];

    return result;
}

- (id)reduce:(id (^)(id, id))block
{
    NSParameterAssert(block != nil);

    __block id result = nil;

    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        result = result ? block(result, obj) : obj;
    }];

    return result;
}

- (NSSet *)filter:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    __block NSMutableSet *result = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) [result addObject:obj];
    }];

    return result;
}

- (id)firstMatch:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    __block id result = nil;

    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            result = obj;
            *stop = YES;
        }
    }];

    return result;
}

@end
