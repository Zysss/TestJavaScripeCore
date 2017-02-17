//
//  HybridObject.h
//  TestJavaScripeCore
//
//  Created by zhangyansong on 2016/10/24.
//  Copyright © 2016年 zysMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol HybridProtocol <JSExport>

- (void) testFunction;

- (void) testFunctionWithString:(JSValue *) string testString:(NSString *) string;

- (NSString *) testFunctionToString;


@end

@interface HybridObject : NSObject<HybridProtocol>

@property (nonatomic, strong) JSValue *jsValue;

@end
