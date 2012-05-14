//
//  NSError+Omazing.m
//  Omazing
//
//  Created by Ethan Lin on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSError+Omazing.h"

@implementation NSError (Omazing)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)desc
{
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:desc, NSLocalizedDescriptionKey, nil];

    return [[[NSError alloc] initWithDomain:domain
                                       code:code
                                   userInfo:infoDict] autorelease];
}

@end
