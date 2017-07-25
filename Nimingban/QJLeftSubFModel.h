//
//  QJLeftSubFModel.h
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJLeftSubFModel : NSObject

@property (nonatomic, strong) NSString *idF;
@property (nonatomic, strong) NSString *fgroup;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *showName;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *interval;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updateAt;
@property (nonatomic, strong) NSString *status;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
