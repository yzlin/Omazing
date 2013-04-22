//
//  NSObject+OmazingTests.m
//  Omazing
//
//  Created by Ethan Lin on 4/22/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <Specta.h>
#define EXP_SHORTHAND
#import <Expecta.h>

#import "Omazing.h"

SpecBegin(NSObject)

describe(@"NSObject", ^{
    it(@"can add a dealloc block being executed while deallocing", ^{
        NSMutableString *str = [NSMutableString new];
        __block BOOL isDealloced = NO;
        [str addDeallocBlock:^{
            isDealloced = YES;
        }];
        [str release];
        expect(isDealloced).to.beTruthy();
    });

    it(@"can add multiple dealloc blocks being executed while deallocing", ^{
        NSMutableString *str = [NSMutableString new];
        __block BOOL is1stBlockDealloced = NO;
        __block BOOL is2ndBlockDealloced = NO;
        __block BOOL is3rdBlockDealloced = NO;
        [str addDeallocBlock:^{
            is1stBlockDealloced = YES;
        }];
        [str addDeallocBlock:^{
            is2ndBlockDealloced = YES;
        }];
        [str addDeallocBlock:^{
            is3rdBlockDealloced = YES;
        }];
        [str release];
        expect(is1stBlockDealloced).to.beTruthy();
        expect(is2ndBlockDealloced).to.beTruthy();
        expect(is3rdBlockDealloced).to.beTruthy();
    });
});

SpecEnd
