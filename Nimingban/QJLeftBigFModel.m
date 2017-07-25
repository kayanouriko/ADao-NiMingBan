//
//  QJLeftBigFModel.m
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJLeftBigFModel.h"
#import "QJLeftSubFModel.h"

@implementation QJLeftBigFModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    QJLeftBigFModel *model = [QJLeftBigFModel new];
    [model setValuesForKeysWithDictionary:dict];
    model.isShow = NO;
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"]) {
        self.idF = value;
    }
    else if ([key isEqualToString:@"forums"]) {
        NSArray *array = (NSArray *)value;
        NSMutableArray<QJLeftSubFModel *> *forums = [NSMutableArray new];
        for (NSDictionary *dict in array) {
            QJLeftSubFModel *model = [QJLeftSubFModel modelWithDict:dict];
            [forums addObject:model];
        }
        self.forumsArr = [forums copy];
    }
}

@end
