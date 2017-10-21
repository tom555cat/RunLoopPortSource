//
//  MyWorkerClass.h
//  MacRunLoopPortTest
//
//  Created by MAC-MiNi on 2017/10/17.
//  Copyright © 2017年 MAC-MiNi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWorkerClass : NSObject

- (void)sendCheckinMessage:(NSPort*)outPort;

- (BOOL)shouldExit;

@end
