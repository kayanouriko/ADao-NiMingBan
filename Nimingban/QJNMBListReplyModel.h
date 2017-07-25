//
//  QJNMBListReplyModel.h
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KHIFastImage.h"
#import "NSString+CustomCatgory.h"

@interface QJNMBListReplyModel : NSObject

@property (nonatomic, strong) NSString *idC;        //串ID
@property (nonatomic, strong) NSString *img;        //图片名字
@property (nonatomic, strong) NSString *ext;        //后缀
@property (nonatomic, strong) NSString *now;        //串创建时间
@property (nonatomic, strong) NSString *userid;     //cookie
@property (nonatomic, strong) NSString *nameC;       //昵称,一般为无名氏
@property (nonatomic, strong) NSString *email;      //email
@property (nonatomic, strong) NSString *titleC;      //标题,一般为无标题
@property (nonatomic, strong) NSString *content;    //内容
@property (nonatomic, strong) NSString *sage;       //是否sage 1 sage 0 可回复
@property (nonatomic, strong) NSString *admin;      //是否管理员权限 1 是 0 否
@property (nonatomic, strong) NSAttributedString *attri; //生成富文本
@property (nonatomic, strong) UIColor *nameColor;   //尊贵象征
@property (nonatomic, assign) CGSize size;          //图片尺寸
@property (nonatomic, assign) CGFloat height;       //显示高度
@property (nonatomic, assign) CGFloat width;        //显示宽度
@property (nonatomic, strong) NSString *thumbImageUrl;  //预览图url
@property (nonatomic, strong) NSString *bigImageUrl;    //大图url
@property (nonatomic, assign) BOOL isGif;           //是否是gif
@property (nonatomic, assign) BOOL isLongImage;     //是否是长图
@property (nonatomic, assign) BOOL isPo;            //是否为PO主

+ (instancetype)modelWithDict:(NSDictionary *)dict isList:(BOOL)isList;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (NSAttributedString *)getSttributedString:(BOOL)isReply;
- (UIColor *)getUserColor;
- (void)getImageSize;

@end
