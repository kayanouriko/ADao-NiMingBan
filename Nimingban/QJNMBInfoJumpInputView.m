//
//  QJNMBInfoJumpInputView.m
//  Nimingban
//
//  Created by QinJ on 2017/7/6.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJNMBInfoJumpInputView.h"

@interface QJNMBInfoJumpInputView ()

- (IBAction)btnAction:(UIButton *)sender;

@end

@implementation QJNMBInfoJumpInputView

- (IBAction)btnAction:(UIButton *)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickBtnWithTag:)]) {
        [self.delegate didClickBtnWithTag:sender.tag - 700];
    }
}

@end
