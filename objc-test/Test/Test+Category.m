//
//  Test+Category.m
//  objc-test
//
//  Created by joker on 2019/6/19.
//

#import "Test.h"
#import "Test+Category.h"

@implementation Test(Category)
+ (void)load {
    NSLog(@"分类+load被调用");
}

+ (void)initialize {
    NSLog(@"分类+initialize被调用");
}
@end
