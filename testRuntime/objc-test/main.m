//
//  main.m
//  objc-test
//
//  Created by GongCF on 2018/12/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Test.h"

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        [Test testWeakResetNil];
        [Test testMsgSendRoutePath];
        [Test testGCD];
        [Test testBlock];
    }
    return 0;
}

void testRunLoop() {
    
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    // Install an input source.
    NSPort* myPort = [NSMachPort port];
    [runLoop addPort:myPort forMode:NSDefaultRunLoopMode];
    
    BOOL exitNow = NO;
    while (!exitNow)
    {
        [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}
