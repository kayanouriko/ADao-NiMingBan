//
//  QJReplyViewController.h
//  Nimingban
//
//  Created by QinJ on 2017/7/10.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJViewController.h"

@class QJNMBListModel;

@protocol QJReplyViewControllerDelagate <NSObject>

@optional
- (void)shouldRefreshUI;

@end

@interface QJReplyViewController : QJViewController

@property (weak, nonatomic) id<QJReplyViewControllerDelagate>delegate;
@property (nonatomic, strong) QJNMBListModel *model;
@property (nonatomic, strong) NSString *number;

@end
