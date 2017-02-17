//
//  ViewController.m
//  TestJavaScripeCore
//
//  Created by zhangyansong on 16/5/24.
//  Copyright © 2016年 zysMac. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "HybridObject.h"

@interface ViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) WKWebView *wkWebView;

@property (strong, nonatomic) JSContext *context;

@property (weak, nonatomic) JSContext *context1;

@property (weak, nonatomic) JSContext *context2;

@end

@implementation ViewController
- (IBAction)back:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (IBAction)testFunction:(id)sender {
    JSValue *value = self.context[@"callJsAlert"];
    [value callWithArguments:@[@"OC alert"]];
    
//    JSManagedValue *managerValue = [JSManagedValue managedValueWithValue:value];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [managerValue.value callWithArguments:@[@"OC alert"]];
//    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view,
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]]]];
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context = context;
    //WKWebViewConfiguration *configration = [[ WKWebViewConfiguration alloc] init];
    //self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:configration];
    //self.wkWebView.UIDelegate = self;
    //self.wkWebView.navigationDelegate = self;
    //[self.view addSubview:self.wkWebView];
    
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"testWebView" ofType:@"html"]]]];
    
//    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
//    [context evaluateScript:alertJS];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context = context;
    //异常处理
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"%@",exception);
        context.exception = exception;
    };
    //格式不匹配返回空值
    JSValue *value1 = [context evaluateScript:@"'aaa'"];
    NSArray *array = [value1 toArray];
    NSString *value1String = [value1 toString];
    NSLog(@"%@,%@",value1String,array);
    
    //JS调用OC
    //注入block
    context[@"callOCFunction"] = ^{
        NSArray *array = [JSContext currentArguments];
        NSLog(@"%@",array);
    };
    //注入JSExport对象
    HybridObject *obj = [ HybridObject new];
    context[@"obj"] = obj;
    
    //OC调用JS
    //执行js语句

    JSValue *value = [context evaluateScript:@"(function test(a,b){return a+b})"];
    JSValue *result = [value callWithArguments:@[@[@3,@5,@5],@5]];
    NSLog(@"%@",result);
    
    //循环引用
    context[@"testValue"] = @"testValue";
    JSValue *testValue =  context[@"testValue"];
    JSManagedValue *testMValue = [JSManagedValue managedValueWithValue:testValue];
    [context.virtualMachine addManagedReference:testMValue withOwner:self];
    context[@"test"] = ^{
//        JSValue *value =  self.context[@"testValue"];
//        NSLog(@"%@",value);
        NSLog(@"%@",testMValue.value);
    };
    [context evaluateScript:@"test()"];
    [context.virtualMachine removeManagedReference:testMValue withOwner:self];
    
    JSValue *testValue1 = [JSValue valueWithBool:YES inContext:context];
    JSContext *testContext = [[ JSContext alloc] initWithVirtualMachine:context.virtualMachine];
    testContext[@"testValue"] = testValue1;
    NSLog(@"------%@",testContext[@"testValue"]);
    self.context1 = testContext;
    
    JSContext *testContext1 = [[ JSContext alloc] init];
    testContext1[@"testValue"] = testValue1;
    NSLog(@"------%@",testContext1[@"testValue"]);
    self.context2 = testContext1;
}


@end
