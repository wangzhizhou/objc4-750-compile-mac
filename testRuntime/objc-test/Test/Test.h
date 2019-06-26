//
//  Test.h
//  objc-test
//
//  Created by joker on 2019/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

@interface Test : NSObject

@property (nonatomic, weak) id weakMember;

+ (void)testWeakResetNil;
+ (void)testMsgSendRoutePath;
+ (void)testGCD;
+ (void)testBlock;

@end

NS_ASSUME_NONNULL_END
