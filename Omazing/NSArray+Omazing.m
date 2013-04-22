//
//  NSArray+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 4/13/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

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

    return [result autorelease];
}

- (id)reduce:(id (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    id result = nil;

    if ([self count] == 1) {
        result = [[self[0] copy] autorelease];
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

    return [result autorelease];
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

    return [result autorelease];
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
    [dict release];

    return result;
}

@end
