//
//  QJNMBListReplyCell.m
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJNMBListReplyCell.h"
#import "QJNMBListReplyModel.h"

@interface QJNMBListReplyCell ()

@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (weak, nonatomic) IBOutlet UILabel *poLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation QJNMBListReplyCell

- (void)refreshUI:(QJNMBListReplyModel *)model {
    self.nowLabel.text = model.now;
    self.useridLabel.text = model.userid;
    self.useridLabel.textColor = model.nameColor;
    self.poLabel.hidden = !model.isPo;
    self.contentLabel.attributedText = model.attri;
    self.contentLabel.font = [UIFont systemFontOfSize:14.f];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
