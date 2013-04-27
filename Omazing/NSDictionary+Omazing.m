// NSDictionary+Omazing.m
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

#import "NSDictionary+Omazing.h"

@implementation NSDictionary (Omazing)

- (BOOL)any:(BOOL (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    return [self firstMatch:block] != nil;
}

- (BOOL)all:(BOOL (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    __block BOOL result = YES;

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!block(key, obj)) {
            result = NO;
            *stop = YES;
        }
    }];

    return result;
}

- (BOOL)none:(BOOL (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    return [self firstMatch:block] == nil;
}

- (void)each:(void (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (NSDictionary *)map:(id (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = block(key, obj);
        result[key] = value ? value : [NSNull null];
    }];

    return result;
}

- (NSDictionary *)filter:(BOOL (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key, obj)) result[key] = obj;
    }];

    return result;
}

- (id)firstMatch:(BOOL (^)(id, id))block
{
    OMZ_NIL_BLOCK_CHECK(block);

    __block id result = nil;

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key, obj)) {
            result = obj;
            *stop = YES;
        }
    }];

    return result;
}

@end
