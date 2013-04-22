//
//  NSObject+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 4/22/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Omazing.h"

static char deallocArrayKey;

@interface OMZDeallocHandler : NSObject

@property (nonatomic, copy, readwrite) void (^deallocBlock)();

@end

@implementation OMZDeallocHandler

- (void)dealloc
{
    if (_deallocBlock) _deallocBlock();

    [_deallocBlock release];

    [super dealloc];
}

@end

@implementation NSObject (Omazing)

- (void)addDeallocBlock:(void (^)())block
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];

    NSMutableArray *deallocBlocks = objc_getAssociatedObject(self, &deallocArrayKey);
    if (!deallocBlocks) {
        deallocBlocks = [NSMutableArray array];
        objc_setAssociatedObject(self, &deallocArrayKey, deallocBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    OMZDeallocHandler *handler = [OMZDeallocHandler new];
    handler.deallocBlock = block;
    [deallocBlocks addObject:handler];
    [handler release];

    [pool release];
}

@end
