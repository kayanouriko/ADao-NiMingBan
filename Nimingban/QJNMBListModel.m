//
//  QJNMBListModel.m
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJNMBListModel.h"

@interface QJNMBListModel ()

@property (nonatomic, assign) BOOL isList;

@end

@implementation QJNMBListModel

+ (instancetype)modelWithDict:(NSDictionary *)dict isList:(BOOL)isList {
    QJNMBListModel *model = [self new];
    model.isList = isList;
    //订阅没这个字段,所以要提前设置初始值
    model.sage = @"0";
    //只有时间线有这两个个字段,所以要提前设置初始值
    model.fid = @"";
    model.fourmName = @"";
    
    [model setValuesForKeysWithDictionary:dict];
    
    //一些数据的特殊处理
    model.isPo = NO;
    model.totalPages = [model.replyCount integerValue] % 19 ? [model.replyCount integerValue] / 19 + 1 : [model.replyCount integerValue] / 19;
    model.attri = [model getSttributedString:NO];
    model.tipStr = [model getTipString];
    model.nameColor = [model getUserColor];
    if (model.img.length) {
        [model getImageSize];
    }
    if (model.fid.length) {
        NSDictionary *forumName = [[QJGlobalInfo sharedInstance] getAttribute:@"ForumName"];
        model.fourmName = [NSString stringWithFormat:@"  %@  ",forumName[model.fid]];
    }
    model.now = [model.now dateWithDateString];
    
    if (model.nameC.length || model.titleC.length) {
        model.nameC = model.nameC.length ? model.nameC : @"无名氏";
        model.titleC = model.titleC.length ? model.titleC : @"无标题";
    }
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"]) {
        self.idC = value;
    }
    else if ([key isEqualToString:@"replys"]) {
        NSArray *array = (NSArray *)value;
        NSMutableArray<QJNMBListReplyModel *> *replys = [NSMutableArray new];
        for (NSDictionary *dict in array) {
            QJNMBListReplyModel *model = [QJNMBListReplyModel modelWithDict:dict isList:self.isList];
            model.isPo = [model.userid isEqualToString:self.userid];
            [replys addObject:model];
        }
        self.replyArr = [replys copy];
    }
    else if ([key isEqualToString:@"name"]) {
        self.nameC = [value isEqualToString:@"无名氏"] ? @"" : value;
    }
    else if ([key isEqualToString:@"title"]) {
        self.titleC = [value isEqualToString:@"无标题"] ? @"" : value;
    }
}

- (NSString *)getTipString {
    NSInteger count = [self.replyCount integerValue] - self.replyArr.count;
    return count ? [NSString stringWithFormat:@"回应有 %ld 篇被省略。要阅读所有回应请按下回应链接。",(long)count] : @"";
}

@end
