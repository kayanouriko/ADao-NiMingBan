//
//  UIImageView+LongImgLabel.m
//  Nimingban
//
//  Created by QinJ on 2017/6/27.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "UIImageView+LongImgLabel.h"
#import <objc/runtime.h>

static const CGFloat labelWidth = 35.f;
static const CGFloat labelHeight = 18.f;
static const CGFloat fontSize = 10.f;

@implementation UIImageView (LongImgLabel)

- (void)addLabel {
    if (self.subviews.count) {
        for (id item in self.subviews) {
            if ([item isKindOfClass:[UILabel class]]) {
                return;
            }
        }
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.337 green:0.467 blue:0.639 alpha:1.00];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:fontSize];
    [self addSubview:label];
    
    self.layer.borderColor = [UIColor colorWithRed:0.337 green:0.467 blue:0.639 alpha:1.00].CGColor;
    self.layer.borderWidth = 0.5f;
}

- (void)showLabelWithGif:(BOOL)isGif {
    if (self.subviews.count) {
        for (id item in self.subviews) {
            if ([item isKindOfClass:[UILabel class]]) {
                ((UILabel *)item).hidden = NO;
                ((UILabel *)item).text = isGif ? @"gif" : @"长图";
            }
        }
    }
    self.layer.borderWidth = 0.5f;
}

- (void)hiddenLabel {
    if (self.subviews.count) {
        for (id item in self.subviews) {
            if ([item isKindOfClass:[UILabel class]]) {
                ((UILabel *)item).hidden = YES;
            }
        }
    }
    self.layer.borderWidth = 0;
}

@end
