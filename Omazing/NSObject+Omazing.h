//
//  NSObject+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 4/22/13.
//  Copyright (c) 2013 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Omazing)

- (void)addDeallocBlock:(void (^)())block;

@end
