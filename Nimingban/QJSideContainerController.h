//
//  QJSideContainerController.h
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJViewController.h"

@class QJSideLeftViewController;
@class ViewController;

@interface QJSideContainerController : QJViewController

@property (nonatomic, assign, getter=isCanDragSide) BOOL canDragSide;
@property (nonatomic, strong) QJSideLeftViewController *leftVC;
@property (nonatomic, strong) UINavigationController *mainVC;

- (void)showSideView;
- (void)hideSideView;

@end
