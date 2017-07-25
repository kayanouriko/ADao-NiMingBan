//
//  QJImageBrowserCell.h
//  Nimingban
//
//  Created by QinJ on 2017/7/7.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QJImageModel;

@protocol QJImageBrowserCellDelagate <NSObject>

@optional
- (void)closeVC;

@end

@interface QJImageBrowserCell : UICollectionViewCell

@property (weak, nonatomic) id<QJImageBrowserCellDelagate>delegate;

- (void)showImageWithModel:(QJImageModel *)model;

@end
