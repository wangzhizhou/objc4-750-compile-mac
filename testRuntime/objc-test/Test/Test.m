//
//  Test.m
//  objc-test
//
//  Created by joker on 2019/6/19.
//

#import "Test.h"
#import "Test+Category.h"
#import "TestBackup.h"
#import "message.h"

static NSInteger globalVal = 0;

@interface Test()
@property(nonatomic, assign)NSInteger intMember;
@end

@implementation Test

+ (void)load {
    NSLog(@"主类+load被调用");
}

+ (void)initialize {
    NSLog(@"主类+initialize被调用");
}

// MARK: weak属性自动置nil原理
+ (void)testWeakResetNil {
    /*
     在文件objc-weak.mm的方法：weak_clear_no_lock处打断点，进行调试理解weak成员为什么会自动置nil,
     及其执行时机
     */
    Test *test = [Test new];
    
    @autoreleasepool {
        Test *anotherTest = [Test new];
        test.weakMember = anotherTest;
        NSLog(@"inner: %@", test.weakMember);
    }
    
    NSLog(@"outer: %@", test.weakMember);
}

// MARK: 消息转发机制
+ (void)testMsgSendRoutePath {
    [Test unimplementClassMethod];
    [[Test new] unimplementInstanceMethod];
}

// MARK: 消息转发机制 - 动态解析
+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"resolveClassMethod: %@", NSStringFromSelector(sel));
    
    if(sel == @selector(unimplementClassMethod)) {
        class_addMethod(object_getClass(self), sel, imp_implementationWithBlock(^{
            NSLog(@"implementClassMethod called!");
        }), "+v@");
    }
    
    return NO;
    
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    NSLog(@"resolveInstanceMethod: %@", NSStringFromSelector(sel));
    
    if( sel == @selector(unimplementInstanceMethod)) {
        class_addMethod(self, sel, imp_implementationWithBlock(^{
            NSLog(@"implementInstanceMethod called!");
        }), "v@");
        return YES;
    }
    
    return NO;
}

// MARK: 消息转发机制 - 备用处理者转发
-(id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector: %@", NSStringFromSelector(aSelector));
    
    // 转给其它对象处理，
    if(aSelector == @selector(unimplementInstanceMethod)) {
        return [TestBackup new];
    }
    
    // 如果没有其它对象可以处理，则返回nil，进行完整消息转发
    return nil;
}

// MARK: 消息转发机制 - 完整转发
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if(aSelector == @selector(unimplementInstanceMethod)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation: %@", anInvocation);
    // 进行完整消息转发
    SEL sel = [anInvocation selector];
    TestBackup *testBack = [TestBackup new];
    if([TestBackup respondsToSelector:sel]){
        [anInvocation invokeWithTarget:testBack];
    }
}

// MARK: GCD多线程
+ (void)testGCD {
    
    BOOL isCallFromMainQueue = YES;
    BOOL isDispatchAsync = YES;
    


    
    [Test section:@"验证异步任务分发" SubTitle:@""];
    [Test testGCDQueueAsync];
}

+ (void)testGCDQueueAsync {
    
    NSLog(@"A");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B");
    });
    NSLog(@"C");
    
}

+ (void)testGCDQueueSync {
    NSLog(@"A");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"B");
    });
    NSLog(@"C");
}

// MARK: Block
+ (void)testBlock {
    
    {
        [Test section:@"block捕获外部局部变量" SubTitle:@"不能对其进行修改，属于值传递"];
        int captureNum = 1;
        void (^block)(void) = ^(){
            NSLog(@"captureNum = %@", @(captureNum));
        };
        captureNum = 2;
        block();
        NSLog(@"block type: %@", block);
        
    }
    
    {
        [Test section:@"block捕获数组，并修改元素" SubTitle:@""];
        typedef void (^captureBlock)(NSObject *);
        captureBlock block;
        
        {
            NSMutableArray *mutableArray = [NSMutableArray new];
            
            block = ^(NSObject *obj) {
                [mutableArray addObject:obj];
                NSLog(@"mutableArray.count = %@", @(mutableArray.count));
            };
        }
        
        block([NSObject new]);
        block([NSObject new]);
        block([NSObject new]);
        NSLog(@"block type: %@", block);
    }
    
    {
        [Test section:@"block捕获外部变量，可以在block内部修改值, 属于引用传递" SubTitle:@""];
        __block int captureNum = 1;
        
        void (^block)(void) = ^(){
            captureNum = 3;
            NSLog(@"inner block - captureNum = %@", @(captureNum));
        };
        block();
        
        NSLog(@"outter block - captureNum = %@", @(captureNum));
        NSLog(@"block type: %@", block);
    }
    
    { 
        [Test section:@"block 可以修改全局变量" SubTitle:@""];
        NSLog(@"before - globalVal = %@", @(globalVal));
        
        void (^block)(void) = ^(){
            globalVal = 1;
        };
        block();
        
        NSLog(@"after - globalVal = %@", @(globalVal));
        NSLog(@"block type: %@", block);
    }
}

// MARK: helper

+ (void)section:(NSString *)title SubTitle:(NSString *)subtitle {
    NSLog(@"\n=== %@ ===", title);
    if(subtitle.length > 0) {
        NSLog(@"\n\t%@\n", subtitle);
    }
}
@end
