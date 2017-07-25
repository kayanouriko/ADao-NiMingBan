//
//  QJSideLeftHeadView.h
//  Nimingban
//
//  Created by QinJ on 2017/6/30.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QJLeftBigFModel;

@protocol QJSideLeftHeadViewDelagate <NSObject>

@optional
- (void)didClickHeadViewWithModel:(QJLeftBigFModel *)model;

@optional

@end

@interface QJSideLeftHeadView : UIView

@property (weak, nonatomic) id<QJSideLeftHeadViewDelagate>delegate;

- (void)refreshUI:(QJLeftBigFModel *)model subTitle:(NSString *)subTitle;

@end
