//
//  ViewController.m
//  testGCD
//
//  Created by joker on 2019/6/26.
//  Copyright © 2019 joker. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self executeOnMainThread:NO Sync:NO];

}

- (void)executeOnMainThread: (BOOL)isMain Sync:(BOOL) isSync {
    
    if(isMain)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSync) {
                [self testGCDSync];
            } else {
                [self testGCDASync];
            }
        });
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if(isSync) {
                [self testGCDSync];
            } else {
                [self testGCDASync];
            }
        });
    }

}

- (void) testGCDASync {
    NSLog(@"A");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B");
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"C");
}

- (void) testGCDSync {
    NSLog(@"A");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"B");
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"C");
}


@end
