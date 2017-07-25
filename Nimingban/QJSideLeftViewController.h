//
//  QJSideLeftViewController.h
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJViewController.h"

@class QJSideContainerController;
@class ViewController;

@interface QJSideLeftViewController : QJViewController

@property (nonatomic, strong) ViewController *mainVC;
@property (nonatomic, strong) QJSideContainerController *fatherVC;

@end
