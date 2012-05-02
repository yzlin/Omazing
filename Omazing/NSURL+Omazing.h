//
//  NSURL+Omazing.h
//  Omazing
//
//  Created by Ethan Lin on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Omazing)

+ (NSURL *)URLByAddingPercentEscapesWithString:(NSString *)URLString;

@end
