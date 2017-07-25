//
//  QJHTTPOperation.m
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJHTTPOperation.h"
#import <UIKit/UIKit.h>
#import "QJUtilTool.h"//???没用上也没事,别的客户端也是直接填写的User-Agent

static const NSString *apiUrl =  @"http://h.adnmb.com/Api";//@"https://h.nimingban.com/Api";
static NSString * const postNewUrl = @"http://h.adnmb.com/Home/Forum/doPostThread.html";//@"https://h.nimingban.com/Home/Forum/doPostThread.html";
static NSString * const replyUrl = @"http://h.adnmb.com/Home/Forum/doReplyThread.html";//@"https://h.nimingban.com/Home/Forum/doReplyThread.html";

@implementation QJPostModel



@end

@implementation QJHTTPOperation

+ (void)getRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    NetworkShow();
    NSString *finalUrl = [apiUrl stringByAppendingString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalUrl]];
    request.HTTPMethod = @"POST";
    NSMutableDictionary *mutParams = [NSMutableDictionary dictionaryWithDictionary:params];
    //同时所有的API调用都应该有一个appid跟在最后
    NSString *uuidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
    [mutParams setValue:uuidStr forKey:@"uuid"];
    [mutParams setValue:uuidStr forKey:@"appid"];
    if (mutParams && mutParams.allKeys.count) {
        request.HTTPBody = [[self getHTTPBodyWithParams:mutParams] dataUsingEncoding:NSUTF8StringEncoding];
    }
    //User-Agent必须为HavfunClient-平台
    [request setValue:@"HavfunClient-iOS_NMB" forHTTPHeaderField:@"User-Agent"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NetworkHidden();
            if (error) {
                failure(error);
                NSLog(@"error --> %@",error);
            }
            else {
                id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                success(responseObject);
                NSLog(@"success --> %@",url);
            }
        });
    }];
    [task resume];
}

+ (NSString *)getHTTPBodyWithParams:(NSDictionary *)params {
    NSMutableString *bodyStr = [NSMutableString new];
    for (NSString *key in params.allKeys) {
        if (bodyStr.length) {
            [bodyStr appendFormat:@"&%@=%@",key,params[key]];
        }
        else {
            [bodyStr appendFormat:@"%@=%@",key,params[key]];
        }
    }
    return bodyStr.copy;
}

+ (void)postNewWithModel:(QJPostModel *)model success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self threadWithModel:model isReply:NO success:success failure:failure];
}

+ (void)replyWithModel:(QJPostModel *)model success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self threadWithModel:model isReply:YES success:success failure:failure];
}

+ (void)threadWithModel:(QJPostModel *)model isReply:(BOOL)isReply success:(SuccessBlock)success failure:(FailureBlock)failure {
    NetworkShow();
    NSString *finalUrl = isReply ? replyUrl : postNewUrl;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalUrl]];
    request.HTTPMethod = @"POST";
    //boundary为随机的,这里直接套用贼贼贼的
    [request setValue:@"multipart/form-data; boundary=-0-x-K-h-T-m-L-b-O-u-N-d-A-r-Y-" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/html" forHTTPHeaderField:@"Accept"];
    //User-Agent必须为HavfunClient-平台
    [request setValue:@"HavfunClient-iOS_NMB" forHTTPHeaderField:@"User-Agent"];
    //cookie 先写死一个账号
    [request setValue:@"userhash=%28e%1F%0E%27%F2%97%EF%A0%D1%C2%EB%A0%D0%07%C5%0B%28%5B%AA%FE%B7M%D6" forHTTPHeaderField:@"Cookie"];
    NSDictionary *params = @{
                             isReply ? @"resto" : @"fid": model.idName,
                             @"title": model.title,
                             @"email": model.email,
                             @"name": model.name,
                             @"content": model.content,
                             @"water": @"true",
                             };
    NSMutableData *requestBody = [NSMutableData new];
    NSString *boundary = @"-0-x-K-h-T-m-L-b-O-u-N-d-A-r-Y-";
    for (NSString *key in params.allKeys) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"%@\r\n",params[key]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    request.HTTPBody = requestBody;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NetworkHidden();
            if (error) {
                failure(error);
                NSLog(@"error --> %@",error);
            }
            else {
                NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                success(html);
                NSLog(@"success --> %@",finalUrl);
            }
        });
    }];
    [task resume];
}

@end
