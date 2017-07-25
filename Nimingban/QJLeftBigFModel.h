//
//  QJLeftBigFModel.h
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QJLeftSubFModel;

@interface QJLeftBigFModel : NSObject

@property (nonatomic, strong) NSString *idF;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sattus;
@property (nonatomic, strong) NSArray<QJLeftSubFModel *> *forumsArr;
@property (nonatomic, assign) BOOL isShow;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
