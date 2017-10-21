//
//  MyWorkerClass.m
//  MacRunLoopPortTest
//
//  Created by MAC-MiNi on 2017/10/17.
//  Copyright © 2017年 MAC-MiNi. All rights reserved.
//

#import "MyWorkerClass.h"

@interface MyWorkerClass () <NSMachPortDelegate>

@property (nonatomic, strong) NSPort *remotePort;

@end

@implementation MyWorkerClass

- (void)sendCheckinMessage:(NSPort*)outPort {
    [self setRemotePort:outPort];
    
    NSPort *myPort = [NSMachPort port];
    [myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    
    NSString *str = @"Hello World!";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSPortMessage *messageObj = [[NSPortMessage alloc] initWithSendPort:outPort receivePort:myPort components:@[data]];
    
    if (messageObj) {
        // Finish configuring the message and send it immediately.
        [messageObj setMsgid:100];
        [messageObj sendBeforeDate:[NSDate date]];
    }
}

- (BOOL)shouldExit {
    return NO;
}

+ (void)LaunchThreadWithPort:(id)inData {
    @autoreleasepool {
        NSPort *distantPort = (NSPort *)inData;
        
        MyWorkerClass *workerObj = [[MyWorkerClass alloc] init];
        [workerObj sendCheckinMessage:distantPort];
        
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (![workerObj shouldExit]);
    }
}


@end
