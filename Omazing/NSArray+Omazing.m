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

#import "OMZUtils.h"

#import "NSArray+Omazing.h"

@implementation NSArray (Omazing)

- (BOOL)any:(BOOL (^)(id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    for (id obj in self) {
        if (block(obj)) {
            return YES;
        }
    }

    return NO;
}

- (BOOL)all:(BOOL (^)(id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    for (id obj in self) {
        if (!block(obj)) {
            return NO;
        }
    }

    return YES;
}

- (NSArray *)map:(id (^)(id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id obj in self) {
        id value = block(obj);
        [result addObject:(value ? value : [NSNull null])];
    }

    return result;
}

- (id)reduce:(id (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    id result = nil;

    if ([self count] == 1) {
        result = [self[0] copy];
    } else if ([self count] > 1) {
        result = block(self[0], self[1]);
        for (id obj in [self subarrayWithRange:NSMakeRange(2, self.count - 2)]) {
            result = block(result, obj);
        }
    }

    return result;
}

- (NSArray *)filter:(BOOL (^)(id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id obj in self) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }

    return result;
}

- (id)firstMatch:(BOOL(^)(id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    for (id obj in self) {
        if (block(obj)) {
            return obj;
        }
    }

    return nil;
}

- (NSArray *)zip:(NSArray *)other with:(id (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

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
    OMZ_NIL_BLOCK_CHECK(block);

    NSMutableDictionary *dict = [NSMutableDictionary new];
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
