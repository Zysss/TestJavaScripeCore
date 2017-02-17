//
//  HybridObject.m
//  TestJavaScripeCore
//
//  Created by zhangyansong on 2016/10/24.
//  Copyright © 2016年 zysMac. All rights reserved.
//

#import "HybridObject.h"

@implementation HybridObject

- (void) testFunction {
    NSLog(@"-----------%@",NSStringFromSelector(_cmd));
}

- (void) testFunctionWithString:(JSValue *) string testString:(NSString *) string {
    
}
- (void) testFunctionWithString:(JSValue *) string {
//    NSArray *array = [JSContext currentArguments];
//    JSValue *value = [JSContext currentCallee];
    NSLog(@"-----------%@,%@",NSStringFromSelector(_cmd),string);
}

- (NSString *) testFunctionToString {
    NSLog(@"-----------%@",NSStringFromSelector(_cmd));
    return NSStringFromSelector(_cmd);
}

@end
