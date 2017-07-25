//
//  QJNMBInfoCell.m
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJNMBInfoCell.h"
#import "QJLabel.h"
#import "QJNMBListModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+LongImgLabel.h"

static const NSString *baseUrl = @"http://img6.nimingban.com/thumb/";
static const NSString *bigUrl = @"http://img6.nimingban.com/image/";

@interface QJNMBInfoCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *idCBtn;
@property (weak, nonatomic) IBOutlet UIImageView *dislikeImageView;
@property (weak, nonatomic) IBOutlet UIView *sageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sageViewHeightLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sageViewTopLine;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewHeightLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewWidthLine;
@property (weak, nonatomic) IBOutlet UILabel *poLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sideViewleftLine;
@property (nonatomic, strong) QJNMBListReplyModel *model;

- (IBAction)btnAction:(UIButton *)sender;

@end

@implementation QJNMBInfoCell

- (void)refreshUI:(id)model type:(QJNMBInfoCellMode)mode {
    if (mode == QJNMBInfoCellModeHead) {
        [self refreshUIWithHead:model];
    }
    else {
        [self refreshUIWithRelpy:model];
    }
}

- (void)refreshUIWithHead:(QJNMBListModel *)model {
    self.model = model;
    self.thumbImageView.image = nil;
    if (model.img.length) {
        if (model.size.height > 0 && model.size.width > 0) {
            self.thumbImageViewHeightLine.constant = model.height;
            self.thumbImageViewWidthLine.constant = model.width;
        } else {
            self.thumbImageViewHeightLine.constant = 120;
            self.thumbImageViewWidthLine.constant = UIScreenWidth() - 30 - 5 - self.sideViewleftLine.constant;
        }
        
        if (model.isLongImage || model.isGif) {
            if (model.isLongImage) {
                [self.thumbImageView showLabelWithGif:NO];
            } else {
                [self.thumbImageView showLabelWithGif:YES];
            }
        }
        else {
            [self.thumbImageView hiddenLabel];
        }
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,model.img,model.ext];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderHandleCookies progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.thumbImageView.image = image;
        }];
    }
    else {
        self.thumbImageViewHeightLine.constant = 0;
        [self.thumbImageView hiddenLabel];
    }
    self.sideViewleftLine.constant = -5.f;
    self.poLabel.text = @"";
    
    self.sageView.hidden = [model.sage isEqualToString:@"0"];
    self.sageViewHeightLine.constant = [model.sage isEqualToString:@"0"] ? 0 : 24;
    self.sageViewTopLine.constant = [model.sage isEqualToString:@"0"] ? 5 : 0;
    
    self.titleNameLabel.text = model.titleC;
    self.nameLabel.text = model.nameC;
    [self.idCBtn setTitle:[NSString stringWithFormat:@"No.%@",model.idC] forState:UIControlStateNormal];
    self.nowLabel.text = model.now;
    self.useridLabel.text = model.userid;
    self.useridLabel.textColor = model.nameColor;
    self.contentTextV.attributedText = model.attri;
    self.contentTextV.font = [UIFont systemFontOfSize:14.f];
}

- (void)refreshUIWithRelpy:(QJNMBListReplyModel *)model {
    self.model = model;
    self.thumbImageView.image = nil;
    if (model.img.length) {
        if (model.size.height > 0 && model.size.width > 0) {
            self.thumbImageViewHeightLine.constant = model.height;
            self.thumbImageViewWidthLine.constant = model.width;
        } else {
            self.thumbImageViewHeightLine.constant = 120;
            self.thumbImageViewWidthLine.constant = UIScreenWidth() - 30 - 5 - self.sideViewleftLine.constant;
        }
        
        if (model.isLongImage || model.isGif) {
            if (model.isLongImage) {
                [self.thumbImageView showLabelWithGif:NO];
            } else {
                [self.thumbImageView showLabelWithGif:YES];
            }
        }
        else {
            [self.thumbImageView hiddenLabel];
        }
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,model.img,model.ext];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderHandleCookies progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            self.thumbImageView.image = image;
        }];
    }
    else {
        self.thumbImageViewHeightLine.constant = 0;
        [self.thumbImageView hiddenLabel];
    }
    
    self.sideViewleftLine.constant = 20.f;
    self.poLabel.text = model.isPo ? @"(PO主)" : @"";
    
    self.sageView.hidden = [model.sage isEqualToString:@"0"];
    self.sageViewHeightLine.constant = [model.sage isEqualToString:@"0"] ? 0 : 24;
    self.sageViewTopLine.constant = [model.sage isEqualToString:@"0"] ? 5 : 0;
    
    self.titleNameLabel.text = model.titleC;
    self.nameLabel.text = model.nameC;
    [self.idCBtn setTitle:[NSString stringWithFormat:@"No.%@",model.idC] forState:UIControlStateNormal];
    self.nowLabel.text = model.now;
    self.useridLabel.text = model.userid;
    self.useridLabel.textColor = model.nameColor;
    self.contentTextV.attributedText = model.attri;
    self.contentTextV.font = [UIFont systemFontOfSize:14.f];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTextV.delegate = self;
    [self.thumbImageView addLabel];
    self.dislikeImageView.image = [self.dislikeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    self.thumbImageView.userInteractionEnabled = YES;
    [self.thumbImageView addGestureRecognizer:tap];
}

#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if (![URL.absoluteString containsString:@"http"]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickQuoteWithNumber:)]) {
            [self.delegate didClickQuoteWithNumber:URL.absoluteString];
        }
        return NO;
    }
    return YES;
}

- (void)showBigImage:(UITapGestureRecognizer *)tap {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickImageViewWIthImage:bigImageUrl:)]) {
        [self.delegate clickImageViewWIthImage:self.thumbImageView.image bigImageUrl:[NSString stringWithFormat:@"%@%@%@",bigUrl,self.model.img,self.model.ext]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickUserNoWithNumber:)]) {
        [self.delegate didClickUserNoWithNumber:[self.idCBtn titleForState:UIControlStateNormal]];
    }
}

@end
