//
//  QJLeftSubFModel.m
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJLeftSubFModel.h"

@implementation QJLeftSubFModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    QJLeftSubFModel *model = [QJLeftSubFModel new];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self.idF = value;
}

@end
