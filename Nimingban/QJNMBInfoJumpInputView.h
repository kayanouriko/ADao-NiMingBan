//
//  QJNMBInfoJumpInputView.h
//  Nimingban
//
//  Created by QinJ on 2017/7/6.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QJNMBInfoJumpInputViewDelagate <NSObject>

@optional
- (void)didClickBtnWithTag:(NSInteger)tag;

@end

@interface QJNMBInfoJumpInputView : UIView

@property (weak, nonatomic) id<QJNMBInfoJumpInputViewDelagate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *jumpTextF;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end
