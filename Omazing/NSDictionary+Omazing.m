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

#import "NSDictionary+Omazing.h"

@implementation NSDictionary (Omazing)

- (BOOL)omz_any:(BOOL (^)(id, id))block
{
    NSParameterAssert(block != nil);

    return [self omz_firstMatch:block] != nil;
}

- (BOOL)omz_all:(BOOL (^)(id, id))block
{
    NSParameterAssert(block != nil);

    __block BOOL result = YES;

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!block(key, obj)) {
            result = NO;
            *stop = YES;
        }
    }];

    return result;
}

- (BOOL)omz_none:(BOOL (^)(id, id))block
{
    NSParameterAssert(block != nil);

    return [self omz_firstMatch:block] == nil;
}

- (void)omz_each:(void (^)(id, id))block
{
    NSParameterAssert(block != nil);

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (NSDictionary *)omz_map:(id (^)(id, id))block
{
    NSParameterAssert(block != nil);

    __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = block(key, obj);
        result[key] = value ? value : [NSNull null];
    }];

    return result;
}

- (NSDictionary *)omz_filter:(BOOL (^)(id, id))block
{
    NSParameterAssert(block != nil);

    __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key, obj)) result[key] = obj;
    }];

    return result;
}

- (id)omz_firstMatch:(BOOL (^)(id, id))block
{
    NSParameterAssert(block != nil);

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
