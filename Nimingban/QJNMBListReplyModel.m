//
//  QJNMBListReplyModel.m
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJNMBListReplyModel.h"
#import "KHIFastImage.h"

static const NSString *kBaseUrl = @"http://img6.nimingban.com/thumb/";
static const NSString *kBigUrl = @"http://img6.nimingban.com/image/";

@interface QJNMBListReplyModel ()

@property (nonatomic, assign) BOOL isList;

@end

@implementation QJNMBListReplyModel

+ (instancetype)modelWithDict:(NSDictionary *)dict isList:(BOOL)isList {
    QJNMBListReplyModel *model = [self new];
    model.isList = isList;
    [model setValuesForKeysWithDictionary:dict];
    model.attri = [model getSttributedString:YES];
    model.nameColor = [model getUserColor];
    if (!isList) {
        [model getImageSize];
    }
    model.now = [model.now dateWithDateString];
    if (model.nameC.length || model.titleC.length) {
        model.nameC = model.nameC.length ? model.nameC : @"无名氏";
        model.titleC = model.titleC.length ? model.titleC : @"无标题";
    }
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"]) {
        self.idC = value;
    }
    else if ([key isEqualToString:@"name"]) {
        self.nameC = [value isEqualToString:@"无名氏"] ? @"" : value;
    }
    else if ([key isEqualToString:@"title"]) {
        self.titleC = [value isEqualToString:@"无标题"] ? @"" : value;
    }
}

- (NSAttributedString *)getSttributedString:(BOOL)isReply {
    NSString *htmlString = self.content;
    //如果是列表,且是回复项,且有图片,在全部的文本前面加上图片两字
    if (self.isList && isReply && self.img.length) {
        htmlString = [NSString stringWithFormat:@"[图片]%@",htmlString];
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //如果是帖子本体,给回复的添加点击事件
    if (!self.isList && [htmlString containsString:@"&gt;&gt;"]) {
        NSRange startRange = [htmlString rangeOfString:@"&gt;&gt;"];
        NSRange endRange = NSMakeRange(htmlString.length, 0);
        if ([htmlString containsString:@"<br"]) {
            endRange = [htmlString rangeOfString:@"<br"];
        }
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [htmlString substringWithRange:range];
        
        [attri addAttribute:NSLinkAttributeName value:[NSURL URLWithString:result] range:NSMakeRange(0, result.length + 2)];
    }
    return attri;
}

- (UIColor *)getUserColor {
    return [self.admin integerValue] ? [UIColor redColor] : CusGrayColor;
}

- (void)getImageSize {
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@%@",kBaseUrl,self.img,self.ext];
    self.thumbImageUrl = imgUrl;
    NSString *bigUrl = [NSString stringWithFormat:@"%@%@%@",kBigUrl,self.img,self.ext];
    self.bigImageUrl = bigUrl;
    self.isGif = [imgUrl hasSuffix:@"gif"];
    NSURL *imageURL = [NSURL URLWithString:imgUrl];
    KHIFastImage *fastImage = [[KHIFastImage alloc] init];
    [fastImage imageSizeAndTypeForURL:imageURL completion:^(CGSize size, KHIFastImageType type, NSError *error) {
        self.size = size;
        //判断显示高度情况
        if (self.size.width / self.size.height > 4 || self.size.height / self.size.width > 4) {
            if (self.size.height < 185.f) {
                self.height = self.size.height;
            } else {
                self.height = 185.f;
            }
            self.width = self.height * self.size.width / self.size.height;
            self.isLongImage = YES;
        }
        else {
            if (self.size.width < UIScreenWidth()) {
                self.height = self.size.height;
            } else {
                self.height = self.size.height * UIScreenWidth() / self.size.width;
            }
            self.width = self.size.width;
            self.isLongImage = NO;
        }
        if (self.width < 45.f) {
            self.width = 45.f;
        }
    }];
}

@end
