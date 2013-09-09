// OMZFileMonitor.m
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

#import "OMZFileMonitor.h"

@interface OMZFileMonitor () {
    dispatch_source_t _source;
}

@property (nonatomic, copy) void (^block)(NSString *path);

- (void)_monitorPath:(NSString *)path withUpdateBlock:(void (^)(NSString *path))block;

@end

@implementation OMZFileMonitor

+ (instancetype)fileMonitorWithPath:(NSString *)path withUpdateBlock:(void (^)(NSString *path))block
{
    return [[self alloc] initWithPath:path withUpdateBlock:block];
}

- (id)initWithPath:(NSString *)path withUpdateBlock:(void (^)(NSString *))block
{
    if (path.length == 0 || block == NULL) return nil;

    if (!(self = [super init])) return nil;

    [self _monitorPath:path withUpdateBlock:block];

    return self;
}

- (void)dealloc
{
    if (_source) {
#if !OS_OBJECT_USE_OBJC
        dispatch_release(_source);
#endif
        _source = NULL;
    }
}

- (void)start
{
    if (_source) dispatch_resume(_source);
}

- (void)stop
{
    if (_source) dispatch_suspend(_source);
}

- (void)_monitorPath:(NSString *)path withUpdateBlock:(void (^)(NSString *path))block
{
    NSParameterAssert(path.length > 0);
    NSParameterAssert(block != NULL);

    self.block = block;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	int fd = open([path UTF8String], O_EVTONLY);

#if !OS_OBJECT_USE_OBJC
    if (_source) dispatch_release(_source);
#endif
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                     fd,
                                     DISPATCH_VNODE_DELETE|DISPATCH_VNODE_WRITE|DISPATCH_VNODE_EXTEND|
                                     DISPATCH_VNODE_ATTRIB|DISPATCH_VNODE_LINK |DISPATCH_VNODE_RENAME|
                                     DISPATCH_VNODE_REVOKE,
                                     queue);

    __weak __typeof__(self) weakSelf = self;
	dispatch_source_set_event_handler(_source, ^{
        __strong __typeof__(self) self = weakSelf;

        unsigned long flags = dispatch_source_get_data(_source);
        if (flags & DISPATCH_VNODE_DELETE) {
            dispatch_source_cancel(_source);
            [self _monitorPath:path withUpdateBlock:self.block];
        }

        if (self.block) self.block(path);
    });

    dispatch_source_set_cancel_handler(_source, ^{
        close(fd);
    });
}

@end
