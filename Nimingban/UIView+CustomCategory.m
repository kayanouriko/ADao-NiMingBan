//
//  UIView+CustomCategory.m
//  Nimingban
//
//  Created by QinJ on 2017/6/30.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "UIView+CustomCategory.h"

@implementation UIView (CustomCategory)

- (UIViewController *)findMyViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
