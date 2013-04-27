// NSArray+Omazing.m
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

#import "NSArray+Omazing.h"

@implementation NSArray (Omazing)

- (BOOL)any:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    return [self firstMatch:block] != nil;
}

- (BOOL)all:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    __block BOOL result = YES;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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

    [self each_i:^(id obj, NSUInteger idx) {
        block(obj);
    }];
}

- (void)each_i:(void (^)(id, NSUInteger))block
{
    NSParameterAssert(block != nil);

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (NSArray *)map:(id (^)(id))block
{
    NSParameterAssert(block != nil);

    __block NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj);
        [result addObject:(value ? value : [NSNull null])];
    }];

    return result;
}

- (id)reduce:(id (^)(id, id))block
{
    NSParameterAssert(block != nil);

    __block id result = nil;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = result ? block(result, obj) : obj;
    }];

    return result;
}

- (NSArray *)filter:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);

    __block NSMutableArray *result = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) [result addObject:obj];
    }];

    return result;
}

- (id)firstMatch:(BOOL(^)(id))block
{
    NSParameterAssert(block != nil);

    __block id result = nil;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            result = obj;
            *stop = YES;
        }
    }];

    return result;
}

- (NSArray *)zip:(NSArray *)other with:(id (^)(id, id))block
{
    NSParameterAssert(block != nil);

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:MIN(self.count, other.count)];

    NSEnumerator *selfEnumerator = self.objectEnumerator;
    NSEnumerator *otherEnumerator = other.objectEnumerator;

    id objA, objB;

    while ((objA = selfEnumerator.nextObject) && (objB = otherEnumerator.nextObject)) {
        id value = block(objA, objB);
        [result addObject:(value ? value : [NSNull null])];
    }

    return result;
}

- (NSArray *)uniq:(id (^)(id))block
{
    NSParameterAssert(block != nil);

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (id obj in self) {
        id key = block(obj);
        key = key ? key : [NSNull null];
        if (dict[key] == nil)
            dict[key] = obj;
    }

    NSArray *result = dict.allValues;

    return result;
}

@end
