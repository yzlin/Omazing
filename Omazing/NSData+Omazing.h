//
//  NSData+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 10/5/12.
//  Copyright (c) 2012 github.com/yzlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Omazing)

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)sha512;

@end
