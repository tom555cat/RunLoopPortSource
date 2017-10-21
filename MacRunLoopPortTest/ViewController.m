//
//  ViewController.m
//  MacRunLoopPortTest
//
//  Created by MAC-MiNi on 2017/10/17.
//  Copyright © 2017年 MAC-MiNi. All rights reserved.
//

#import "ViewController.h"
#import "MyWorkerClass.h"

#define kCheckinMessage 100

@interface ViewController () <NSPortDelegate>

@property (nonatomic, strong) NSPort *distantPort;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self launchThread];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)launchThread
{
    NSPort* myPort = [NSMachPort port];
    if (myPort)
    {
        // This class handles incoming port messages.
        [myPort setDelegate:self];
        
        // Install the port as an input source on the current run loop.
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        // Detach the thread. Let the worker release the port.
        [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:)
                                 toTarget:[MyWorkerClass class] withObject:myPort];
    }
}

// Handle responses from the worker thread.
- (void)handlePortMessage:(NSPortMessage *)portMessage
{
    unsigned int message = [portMessage msgid];
    NSPort* distantPort = nil;
    
    if (message == kCheckinMessage)
    {
        // Get the worker thread’s communications port.
        distantPort = [portMessage sendPort];
        
        // Retain and save the worker port for later use.
        [self storeDistantPort:distantPort];
        
        NSLog(@"Get message from remote Port: %@!", [[NSString alloc] initWithData: portMessage.components[0] encoding:NSUTF8StringEncoding]);
    }
    else
    {
        // Handle other messages.
    }
}

- (void)storeDistantPort:(NSPort *)distantPort {
    self.distantPort = distantPort;
}

@end
