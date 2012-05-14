//
//  NSURL+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSURL+Omazing.h"

@implementation NSURL (Omazing)

+ (NSURL *)URLByAddingPercentEscapesWithString:(NSString *)URLString
{
    return [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
