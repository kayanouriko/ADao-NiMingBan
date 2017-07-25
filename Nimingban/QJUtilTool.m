//
//  QJUtilTool.m
//  Nimingban
//
//  Created by QinJ on 2017/7/3.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJUtilTool.h"
#import <WebKit/WebKit.h>

@interface QJUtilTool ()<WKNavigationDelegate>

@property (nonatomic, strong) NSString *uaString;
@property (nonatomic, strong) SysUABlock block;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation QJUtilTool

+ (QJUtilTool *)shareTool {
    static QJUtilTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [QJUtilTool new];
    });
    return sharedInstance;
}

- (void)changeSystemUAWithBlock:(SysUABlock)block {
    if (self.uaString.length) {
        block(YES);
        return;
    }
    else {
        self.block = block;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

#pragma mark -WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *oldAgent = result;
        
        // 给User-Agent添加额外的信息
        NSString *newAgent = [NSString stringWithFormat:@"%@ %@", oldAgent, @"HavfunClient-iOS_NMB"];
        self.uaString = newAgent;
        self.block(YES);
        // 设置global User-Agent
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }];
}

#pragma mark -getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
