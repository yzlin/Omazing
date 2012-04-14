//
//  NSArray+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Omazing)

- (BOOL)any:(BOOL (^)(id))block;
- (BOOL)all:(BOOL (^)(id))block;
- (NSArray *)map:(id (^)(id))block;
- (id)reduce:(id (^)(id, id))block;
- (NSArray *)filter:(BOOL (^)(id))block;
- (id)firstMatch:(BOOL (^)(id))block;
- (NSArray *)zip:(NSArray *)other with:(id (^)(id, id))block;
- (NSArray *)uniq:(id (^)(id))block;

@end
