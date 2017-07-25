//
//  QJImageModel.m
//  Nimingban
//
//  Created by QinJ on 2017/7/7.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJImageModel.h"

@implementation QJImageModel

+ (QJImageModel *)creatModelWithImage:(UIImage *)thumbImage bigUrl:(NSString *)bigUrl description:(NSString *)descriptionInfo {
    QJImageModel *model = [QJImageModel new];
    model.thumbImage = thumbImage;
    model.bigUrl = bigUrl;
    model.descriptionInfo = descriptionInfo;
    return model;
}

@end
