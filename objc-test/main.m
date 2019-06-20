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
    }
    return 0;
}


