//
//  Test.h
//  objc-test
//
//  Created by joker on 2019/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Test : NSObject

@property (nonatomic, weak) id weakMember;

+ (void)testWeakResetNil;
+ (void)testMsgSendRoutePath;
+ (void)TestGCD;

@end

NS_ASSUME_NONNULL_END
