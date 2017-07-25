//
//  QJReplyViewCell.m
//  Nimingban
//
//  Created by QinJ on 2017/7/12.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJReplyViewCell.h"

static NSString *const kQJReplyViewCellTypeNormal = @"QJReplyViewCellTypeNormal";
static NSString *const kQJReplyViewCellTypeContent = @"QJReplyViewCellTypeContent";
static NSString *const kQJReplyViewCellTypeUploadImage = @"QJReplyViewCellTypeUploadImage";

@interface QJReplyViewCell ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;

- (IBAction)btnAction:(UIButton *)button;

@end

@implementation QJReplyViewCell

+ (QJReplyViewCell *)creatCellWithtableView:(UITableView *)tableView type:(QJReplyViewCellType)type {
    NSString *identifier = @"";
    switch (type) {
        case QJReplyViewCellTypeNormal:
        {
            identifier = kQJReplyViewCellTypeNormal;
        }
            break;
        case QJReplyViewCellTypeContent:
        {
            identifier = kQJReplyViewCellTypeContent;
        }
            break;
        case QJReplyViewCellTypeUploadImage:
        {
            identifier = kQJReplyViewCellTypeUploadImage;
        }
            break;
        default:
            break;
    }
    QJReplyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QJReplyViewCell" owner:self options:nil][type];
        cell.type = type;
    }
    return cell;
}

- (void)refreshUI:(NSString *)title {
    self.titleLabel.text = title;
    if (self.type == QJReplyViewCellTypeNormal) {
        self.textF.placeholder = title;
    }
    else if (self.type == QJReplyViewCellTypeContent) {
        if (self.number && [title isEqualToString:@"正文"]) {
            self.textV.text = [NSString stringWithFormat:@">>%@\n",self.number];
        }
    }
    else if (self.type == QJReplyViewCellTypeUploadImage) {
        
    }
}

- (IBAction)btnAction:(UIButton *)button {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(showSheetView)]) {
        [self.delegate showSheetView];
    }
}

#pragma mark -代理
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(changeValueWithKey:value:)]) {
        [self.delegate changeValueWithKey:self.titleLabel.text value:textField.text];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(changeValueWithKey:value:)]) {
        [self.delegate changeValueWithKey:self.titleLabel.text value:textView.text];
    }
}

#pragma mark -setter
- (void)setType:(QJReplyViewCellType)type {
    _type = type;
    if (_type == QJReplyViewCellTypeNormal) {
        self.textF.delegate = self;
    }
    else if (_type == QJReplyViewCellTypeContent) {
        self.textV.delegate = self;
        
        self.textV.layer.cornerRadius = 5.f;
        self.textV.layer.borderColor = [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1.00].CGColor;
        self.textV.layer.borderWidth = 0.5f;
    }
    else if (self.type == QJReplyViewCellTypeUploadImage) {
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
