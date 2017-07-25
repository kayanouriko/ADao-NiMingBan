//
//  QJHTTPOperation.h
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJPostModel : NSObject

@property (nonatomic, strong) NSString *idName;//如果是发帖这个为版块id,回复则为串id
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign, getter=isWater) BOOL water;//如果有图片则是ture 没图片为false
@property (nonatomic, strong) UIImage *iamge;

@end

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

@interface QJHTTPOperation : NSObject

+ (void)getRequestWithURL:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
//发帖
+ (void)postNewWithModel:(QJPostModel *)model success:(SuccessBlock)success failure:(FailureBlock)failure;
//回复
+ (void)replyWithModel:(QJPostModel *)model success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
