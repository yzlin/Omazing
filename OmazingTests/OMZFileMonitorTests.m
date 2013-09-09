// OMZFileMonitorTests.m
//
// Copyright (c) 2013 github.com/yzlin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <Specta.h>
#define EXP_SHORTHAND
#import <Expecta.h>

#import "Omazing.h"

SpecBegin(OMZFileMonitor)

describe(@"File Monitoring", ^{

    it(@"should be notified when monitored file being touched", ^{
        __block BOOL isChanged = NO;

        NSString *tmpFile = [@"/tmp/" stringByAppendingString:[NSString omz_uuid]];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr createFileAtPath:tmpFile contents:nil attributes:nil]) {
            OMZFileMonitor *monitor = [OMZFileMonitor fileMonitorWithPath:tmpFile withUpdateBlock:^(NSString *path) {
                isChanged = YES;
            }];

            [monitor start];

            expect(isChanged).to.beFalsy();

            [fileMgr setAttributes:@{ NSFileModificationDate: [NSDate date] }
                      ofItemAtPath:tmpFile
                             error:NULL];

            expect(isChanged).will.beTruthy();

            [monitor stop];

            [fileMgr removeItemAtPath:tmpFile error:NULL];
        } else {
            @throw [NSException exceptionWithName:@"FileNotFoundException"
                                           reason:@"Cannot create tmp file for monitoring"
                                         userInfo:nil];
        }
    });

    it(@"should be notified when monitored file being replaced by another file", ^{
        __block BOOL isChanged = NO;

        NSString *tmpFile1 = [@"/tmp/" stringByAppendingString:[NSString omz_uuid]];
        NSString *tmpFile2 = [@"/tmp/" stringByAppendingString:[NSString omz_uuid]];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr createFileAtPath:tmpFile1 contents:nil attributes:nil] &&
            [fileMgr createFileAtPath:tmpFile2 contents:nil attributes:nil])
        {
            OMZFileMonitor *monitor = [OMZFileMonitor fileMonitorWithPath:tmpFile1 withUpdateBlock:^(NSString *path) {
                isChanged = YES;
            }];

            [monitor start];

            expect(isChanged).to.beFalsy();

            // move and overwrite
            [fileMgr removeItemAtPath:tmpFile1 error:NULL];
            [fileMgr moveItemAtPath:tmpFile2 toPath:tmpFile1 error:NULL];

            expect(isChanged).will.beTruthy();

            [monitor stop];

            [fileMgr removeItemAtPath:tmpFile1 error:NULL];
        } else {
            @throw [NSException exceptionWithName:@"FileNotFoundException"
                                           reason:@"Cannot create tmp file for monitoring"
                                         userInfo:nil];
        }
    });

});

SpecEnd
