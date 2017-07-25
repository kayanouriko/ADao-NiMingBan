//
//  ViewController.h
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJViewController.h"

@class QJSideContainerController;

typedef NS_ENUM(NSInteger, ViewControllerType) {
    ViewControllerTypeNormal,
    ViewControllerTypeLike,
    ViewControllerTypeTimeLine
};

@interface ViewController : QJViewController

@property (nonatomic, strong) QJSideContainerController *fatherVC;

- (void)updateResourceWithNewId:(NSString *)idF title:(NSString *)title type:(ViewControllerType)type;

@end

