//
//  QJTableView.h
//  Nimingban
//
//  Created by QinJ on 2017/7/4.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//
//  集成刷新状态 实现下拉平滑刷新更多数据

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QJTableViewRefreshStatus) {
    QJTableViewRefreshStatusNormal,         //普通状态
    QJTableViewRefreshStatusPull,           //拖拽状态
    QJTableViewRefreshStatusRefresh,        //重新刷新数据状态
    QJTableViewRefreshStatusUpMore,         //上拉加载更多状态
    QJTableViewRefreshStatusDownMore,       //下拉加载更多状态
    QJTableViewRefreshStatusNoNeedRefresh   //无需加载更多状态
};

@interface QJTableView : UITableView

@property (nonatomic, assign) QJTableViewRefreshStatus status;

@end
