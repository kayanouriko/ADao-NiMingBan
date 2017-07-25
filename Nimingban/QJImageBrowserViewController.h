//
//  QJImageBrowserViewController.h
//  Nimingban
//
//  Created by QinJ on 2017/7/7.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QJImageModel.h"

@interface QJImageBrowserViewController : UIViewController

@property (nonatomic, strong) NSArray<QJImageModel *> *photos;

@end
