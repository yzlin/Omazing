//
//  OMZUtils.h
//  Omazing
//
//  Created by Ethan Lin on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OMZ_NIL_BLOCK_CHECK(blk) \
    do { \
        if ((blk) == nil) \
            [NSException raise:NSInvalidArgumentException format:@"Block cannot be null."]; \
    } while(NO)


@interface OMZUtils : NSObject

@end
