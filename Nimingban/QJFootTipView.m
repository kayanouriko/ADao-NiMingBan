//
//  QJFootTipView.m
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJFootTipView.h"

@implementation QJFootTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth(), 30)];
        self.tipLabel.text = @"数据已加载完毕";
        self.tipLabel.textColor = CusGrayColor;
        self.tipLabel.font = [UIFont systemFontOfSize:12.f];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tipLabel];
        self.frame = self.tipLabel.frame;
    }
    return self;
}

@end
