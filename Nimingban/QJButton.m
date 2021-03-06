//
//  QJButton.m
//  Nimingban
//
//  Created by QinJ on 2017/6/27.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJButton.h"

@implementation QJButton

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

@end
