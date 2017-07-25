//
//  QJNMBInfoCell.h
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QJNMBInfoCellMode) {
    QJNMBInfoCellModeHead,//段头
    QJNMBInfoCellModeReply,//回复
};

@protocol QJNMBInfoCellDelagate <NSObject>

@optional
- (void)clickImageViewWIthImage:(UIImage *)image bigImageUrl:(NSString *)bigUrl;
- (void)didClickUserNoWithNumber:(NSString *)number;
- (void)didClickQuoteWithNumber:(NSString *)number;

@end

@interface QJNMBInfoCell : UITableViewCell

@property (weak, nonatomic) id<QJNMBInfoCellDelagate>delegate;

- (void)refreshUI:(id)model type:(QJNMBInfoCellMode)mode;

@end
