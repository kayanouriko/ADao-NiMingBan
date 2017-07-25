//
//  QJNMBListModel.h
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJNMBListReplyModel.h"

@interface QJNMBListModel : QJNMBListReplyModel

@property (nonatomic, strong) NSString *fid;    //所属板块名
@property (nonatomic, strong) NSString *replyCount; //回复数量
@property (nonatomic, assign) NSInteger totalPages;  //总页码
@property (nonatomic, strong) NSString *fourmName; //板块名
@property (nonatomic, strong) NSString *tipStr;
@property (nonatomic, strong) NSArray<QJNMBListReplyModel *> *replyArr; //回复对象集合

@end
