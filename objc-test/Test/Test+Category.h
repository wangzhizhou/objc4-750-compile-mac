//
//  Test+Category.h
//  objc-test
//
//  Created by joker on 2019/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Test(Category)

+ (void)unimplementClassMethod;
- (void)unimplementInstanceMethod;
@end

NS_ASSUME_NONNULL_END
