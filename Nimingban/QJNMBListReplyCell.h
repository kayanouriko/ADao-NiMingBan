//
//  QJNMBListReplyCell.h
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QJNMBListReplyModel;

@interface QJNMBListReplyCell : UITableViewCell

- (void)refreshUI:(QJNMBListReplyModel *)model;

@end
