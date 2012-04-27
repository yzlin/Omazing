//
//  OmazingTests.m
//  OmazingTests
//
//  Created by Ethan Lin on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Omazing.h"

#import "OmazingTests.h"

@implementation OmazingTests

@synthesize testArray = testArray_;
@synthesize testNumArray = testNumArray_;

- (void)setUp {
    [super setUp];

    testArray_ = [[NSArray arrayWithObjects:@"a:one", @"b:two", @"a:three", @"b:four", nil] retain];
    testNumArray_ = [[NSArray arrayWithObjects:
                      [NSNumber numberWithInt:1],
                      [NSNumber numberWithInt:2],
                      [NSNumber numberWithInt:3],
                      [NSNumber numberWithInt:4],
                      [NSNumber numberWithInt:5], nil] retain];
}

- (void)tearDown {
    [testArray_ release];
    testArray_ = nil;
    [testNumArray_ release];
    testNumArray_ = nil;

    [super tearDown];
}

/*
 * NSArray Extension Test
 */

- (void)testNSArray_Base {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    const NSString *desc = @"Should throw exception when block is nil.";
    STAssertThrowsSpecificNamed([self.testArray any:nil], NSException, NSInvalidArgumentException, desc);
    STAssertThrowsSpecificNamed([self.testArray all:nil], NSException, NSInvalidArgumentException, desc);
    STAssertThrowsSpecificNamed([self.testArray map:nil], NSException, NSInvalidArgumentException, desc);
    STAssertThrowsSpecificNamed([self.testArray reduce:nil], NSException, NSInvalidArgumentException, desc);
    STAssertThrowsSpecificNamed([self.testArray filter:nil], NSException, NSInvalidArgumentException, desc);
    STAssertThrowsSpecificNamed([self.testArray firstMatch:nil], NSException, NSInvalidArgumentException, desc);
    STAssertThrowsSpecificNamed([self.testArray zip:nil with:nil], NSException, NSInvalidArgumentException, desc);
    STAssertThrowsSpecificNamed([self.testArray uniq:nil], NSException, NSInvalidArgumentException, desc);
}

- (void)testNSArray_All {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    STAssertTrue([self.testNumArray all:^BOOL(id x) { return [x intValue] < 10; }], nil);
    STAssertFalse([self.testNumArray all:^BOOL(id x) { return [x intValue] > 3; }], nil);
}

- (void)testNSArray_Any {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    STAssertFalse([self.testNumArray any:^BOOL(id x) { return [x intValue] > 10; }], nil);
    STAssertTrue([self.testNumArray any:^BOOL(id x) { return [x intValue] > 3; }], nil);
}

- (void)testNSArray_Map {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSArray *result = nil;
    NSArray *expected = nil;

    result = [self.testNumArray map:^NSNumber *(NSNumber *x) { return nil; }];
    expected = [NSArray arrayWithObjects:
                [NSNull null],
                [NSNull null],
                [NSNull null],
                [NSNull null],
                [NSNull null],
                nil];
    STAssertTrue([result isEqualToArray:expected], nil);

    result = [self.testNumArray map:^NSNumber *(NSNumber *x) { return [NSNumber numberWithInt:[x intValue] + 1]; }];
    expected = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:3],
                [NSNumber numberWithInt:4],
                [NSNumber numberWithInt:5],
                [NSNumber numberWithInt:6],
                nil];
    STAssertTrue([result isEqualToArray:expected], nil);
}

- (void)testNSArray_Reduce {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    STAssertEquals([self.testNumArray reduce:^NSNumber *(NSNumber *x, NSNumber *y) {
        return [NSNumber numberWithInt:[x intValue] + [y intValue]];
    }], [NSNumber numberWithInt: 15], nil);

    STAssertNil([self.testNumArray reduce:^NSNumber *(NSNumber *x, NSNumber *y) {
        return nil;
    }], nil);
}

- (void)testNSArray_Filter {
    NSArray *result = nil;
    NSArray *expected = nil;

    result = [self.testNumArray filter:^BOOL(NSNumber *x) { return NO; }];
    STAssertNotNil(result, nil);
    STAssertTrue([result count] == 0, nil);

    result = [self.testNumArray filter:^BOOL(NSNumber *x) { return YES; }];
    STAssertNotNil(result, nil);
    STAssertTrue([result isEqualToArray:self.testNumArray], nil);

    result = [self.testNumArray filter:^BOOL(NSNumber *x) { return [x intValue] < 3; }];
    expected = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:2],
                nil];
    STAssertTrue([result isEqualToArray:expected], nil);

    result = [self.testArray filter:^BOOL(NSString *x) { return [x hasPrefix:@"a:"]; }];
    expected = [NSArray arrayWithObjects:@"a:one", @"a:three", nil];
    STAssertTrue([result isEqualToArray:expected], nil);
}

- (void)testNSArray_FirstMatch {
    STAssertNil([self.testNumArray firstMatch:^BOOL(NSNumber *x) { return NO; }], nil);
    STAssertNil([self.testArray firstMatch:^BOOL(NSString *x) { return [x hasPrefix:@"NoSuchPrefix"]; }], nil);
    STAssertEquals([self.testNumArray firstMatch:^BOOL(NSNumber *x) { return [x intValue] == 2; }], [NSNumber numberWithInt:2], nil);
    STAssertEquals([self.testArray firstMatch:^BOOL(NSString *x) { return [x hasPrefix:@"a:"]; }], @"a:one", nil);
}

- (void)testNSArray_Zip {
    NSArray *result = nil;
    NSArray *expected = nil;

    result = [self.testNumArray zip:nil with:^id(NSNumber *x, id y) { return nil; }];
    STAssertNotNil(result, nil);
    STAssertEquals([result count], (NSUInteger)0, nil);

    expected = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:0],
                [NSNumber numberWithInt:1],
                nil];
    result = [self.testNumArray zip:expected
                               with:^NSNumber *(NSNumber *x, NSNumber *y) { return y; }];
    STAssertNotNil(result, nil);
    STAssertTrue([result isEqualToArray:expected], nil);

    expected = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:3],
                [NSNumber numberWithInt:4],
                [NSNumber numberWithInt:5],
                [NSNumber numberWithInt:6],
                nil];
    result = [self.testNumArray zip:expected
                               with:^NSNumber *(NSNumber *x, NSNumber *y) { return y; }];
    STAssertNotNil(result, nil);
    STAssertTrue([result isEqualToArray:[expected subarrayWithRange:NSMakeRange(0, 5)]], nil);

    result = [self.testNumArray zip:expected
                               with:^NSNumber *(NSNumber *x, NSNumber *y) { return x; }];
    STAssertNotNil(result, nil);
    STAssertTrue([result isEqualToArray:self.testNumArray], nil);

    expected = [NSArray arrayWithObjects:
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:4],
                [NSNumber numberWithInt:9],
                [NSNumber numberWithInt:16],
                [NSNumber numberWithInt:25],
                nil];
    result = [self.testNumArray zip:self.testNumArray
                               with:^NSNumber *(NSNumber *x, NSNumber *y) {
                                   return [NSNumber numberWithInt:[x intValue] * [y intValue]];
                               }];
    STAssertNotNil(result, nil);
    STAssertTrue([result isEqualToArray:expected], nil);
}

- (void)testNSArray_Uniq {
    NSArray *result = nil;
    NSArray *expected = nil;

    result = [self.testNumArray uniq:^NSNumber *(NSNumber *x) { return nil; }];
    STAssertNotNil(result, nil);
    STAssertEquals([result count], (NSUInteger)1, nil);
    STAssertEquals([result objectAtIndex:0], [NSNumber numberWithInt:1], nil);

    result = [self.testArray uniq:^NSString *(NSString *x) { return [x substringToIndex:1]; }];
    expected = [NSArray arrayWithObjects:
                @"a:one",
                @"b:two",
                nil];
    STAssertNotNil(result, nil);
    STAssertTrue([result isEqualToArray:expected], nil);
}

/*
 * NSString Extension Test
 */

- (void)testNSString_Base {
    STAssertTrue([NSString isNilOrEmpty:nil], nil);
    STAssertTrue([NSString isNilOrEmpty:@""], nil);
}

- (void)testNSString_ArrayWithMatchedRegex {
    NSArray *result = nil;
    NSArray *expected = nil;
    
    result = [@"https://www.httpdomain.com" arrayWithMatchedRegex:@"https?"];
    expected = [NSArray arrayWithObjects:
                @"https",
                @"http",
                nil];
    STAssertTrue([result isEqualToArray:expected], nil);

    result = [@"https://www.httpdomain.com" arrayWithMatchedRegex:@"\\w+"];
    expected = [NSArray arrayWithObjects:
                @"https",
                @"www",
                @"httpdomain",
                @"com",
                nil];
    STAssertTrue([result isEqualToArray:expected], nil);
    
    result = [@"https://www.httpdomain.com" arrayWithMatchedRegex:@"(https|(http\\w+))"];
    expected = [NSArray arrayWithObjects:
                @"https",
                @"httpdomain",
                nil];
    STAssertTrue([result isEqualToArray:expected], nil);
}

@end
