//
//  QJReplyViewCell.h
//  Nimingban
//
//  Created by QinJ on 2017/7/12.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QJReplyViewCellType) {
    QJReplyViewCellTypeNormal,//普通输入模式
    QJReplyViewCellTypeContent,//内容输入模式
    QJReplyViewCellTypeUploadImage,//图片上传
};

@protocol QJReplyViewCellDelagate <NSObject>

@optional
- (void)changeValueWithKey:(NSString *)key value:(NSString *)value;
- (void)showSheetView;

@end

@interface QJReplyViewCell : UITableViewCell

@property (nonatomic, assign) QJReplyViewCellType type;
@property (weak, nonatomic) id<QJReplyViewCellDelagate>delegate;
@property (nonatomic, strong) NSString *number;

+ (QJReplyViewCell *)creatCellWithtableView:(UITableView *)tableView type:(QJReplyViewCellType)type;
- (void)refreshUI:(NSString *)title;

@end
