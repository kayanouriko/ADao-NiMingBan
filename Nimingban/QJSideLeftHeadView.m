//
//  QJSideLeftHeadView.m
//  Nimingban
//
//  Created by QinJ on 2017/6/30.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJSideLeftHeadView.h"
#import "QJLeftBigFModel.h"

@interface QJSideLeftHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) QJLeftBigFModel *model;

@end

@implementation QJSideLeftHeadView

- (void)refreshUI:(QJLeftBigFModel *)model subTitle:(NSString *)subTitle {
    self.rightImageView.transform = CGAffineTransformIdentity;
    if (subTitle) {
        self.headTitleLabel.text = subTitle;
        self.rightImageView.hidden = YES;
        return;
    }
    self.model = model;
    self.headTitleLabel.text = model.name;
    self.rightImageView.hidden = NO;
    if (model.isShow) {
        self.rightImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *image = self.rightImageView.image;
    self.rightImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:self.tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    self.model.isShow = !self.model.isShow;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickHeadViewWithModel:)]) {
        [self.delegate didClickHeadViewWithModel:self.model];
    }
}

#pragma mark -getter
- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tap;
}

@end
