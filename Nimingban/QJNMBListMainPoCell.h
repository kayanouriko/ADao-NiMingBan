//
//  QJNMBListMainPoCell.h
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QJNMBListModel;

@protocol QJNMBListMainPoCellDelagate <NSObject>

@optional
- (void)clickImageViewWIthImage:(UIImage *)image bigImageUrl:(NSString *)bigUrl;

@end

@interface QJNMBListMainPoCell : UITableViewCell

@property (weak, nonatomic) id<QJNMBListMainPoCellDelagate>delegate;
- (void)refreshUI:(QJNMBListModel *)model;

@end
