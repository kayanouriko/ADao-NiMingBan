//
//  QJTableView.m
//  Nimingban
//
//  Created by QinJ on 2017/7/4.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJTableView.h"

@implementation QJTableView

/*
//重写set方法,当状态为下拉刷新的时候,让tableview的偏移量维持在原先的位置
- (void)setContentSize:(CGSize)contentSize {
    if (self.status == QJTableViewRefreshStatusDownMore && !CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        if (contentSize.height > self.contentSize.height) {
            CGPoint offset = self.contentOffset;
            offset.y += (contentSize.height - self.contentSize.height);
            self.contentOffset = offset;
        }
    }
    [super setContentSize:contentSize];
}
*/
@end
