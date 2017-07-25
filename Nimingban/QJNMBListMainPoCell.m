//
//  QJNMBListMainPoCell.m
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJNMBListMainPoCell.h"
#import "QJNMBListModel.h"
#import "QJLabel.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+LongImgLabel.h"

@interface QJNMBListMainPoCell ()

@property (weak, nonatomic) IBOutlet QJLabel *fourmLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *sageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sageViewHeightLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sageViewTopLine;
@property (weak, nonatomic) IBOutlet UIImageView *dislikeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tumbImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewHeightLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewWidthLine;

@property (nonatomic, strong) QJNMBListModel *model;

@end

@implementation QJNMBListMainPoCell

- (void)refreshUI:(QJNMBListModel *)model {
    self.model = model;
    self.tumbImageView.image = nil;
    if (model.img.length) {
        if (model.size.height > 0 && model.size.width > 0) {
            self.thumbImageViewHeightLine.constant = model.height;
            self.thumbImageViewWidthLine.constant = model.width;
        } else {
            self.thumbImageViewHeightLine.constant = 120.f;
            self.thumbImageViewWidthLine.constant = UIScreenWidth() - 30;
        }
        if (model.isLongImage || model.isGif) {
            if (model.isLongImage) {
                [self.tumbImageView showLabelWithGif:NO];
            } else {
                [self.tumbImageView showLabelWithGif:YES];
            }
        }
        else {
            [self.tumbImageView hiddenLabel];
        }
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:model.thumbImageUrl] options:SDWebImageDownloaderHandleCookies progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.tumbImageView.image = image;
        }];
    }
    else {
        self.thumbImageViewHeightLine.constant = 0;
        [self.tumbImageView hiddenLabel];
    }
    self.fourmLabel.text = model.fourmName;
    
    self.sageView.hidden = [model.sage isEqualToString:@"0"];
    self.sageViewHeightLine.constant = [model.sage isEqualToString:@"0"] ? 0 : 24;
    self.sageViewTopLine.constant = [model.sage isEqualToString:@"0"] ? 5 : 0;
    
    self.titleNameLabel.text = model.titleC;
    self.nameLabel.text = model.nameC;
    self.idCLabel.text = [NSString stringWithFormat:@"No.%@",model.idC];
    self.nowLabel.text = model.now;
    self.useridLabel.text = model.userid;
    self.useridLabel.textColor = model.nameColor;
    self.tipLabel.text = model.tipStr;
    self.contentLabel.attributedText = model.attri;
    self.contentLabel.font = [UIFont systemFontOfSize:14.f];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tumbImageView addLabel];
    self.dislikeImageView.image = [self.dislikeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    self.tumbImageView.userInteractionEnabled = YES;
    [self.tumbImageView addGestureRecognizer:tap];
}

- (void)showBigImage:(UITapGestureRecognizer *)tap {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickImageViewWIthImage:bigImageUrl:)]) {
        [self.delegate clickImageViewWIthImage:self.tumbImageView.image bigImageUrl:self.model.bigImageUrl];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
