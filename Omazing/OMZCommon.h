//
//  OMZCommon.h
//  Omazing
//
//  Created by Ethan Lin on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Omazing_OMZCommon_h
#define Omazing_OMZCommon_h

#define OMZ_NIL_BLOCK_CHECK(blk) do { if ((blk) == nil) [NSException raise:NSInvalidArgumentException format:@"Block cannot be null."]; } while (NO)

#endif
