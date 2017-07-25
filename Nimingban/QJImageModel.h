//
//  QJImageModel.h
//  Nimingban
//
//  Created by QinJ on 2017/7/7.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJImageModel : NSObject

//预览图url,使用sd缓存,所以直接用url就好了,下载好了直接取image,没有就下载url
@property (nonatomic, strong) UIImage *thumbImage;
//大图url
@property (nonatomic, strong) NSString *bigUrl;
//描述
@property (nonatomic, strong) NSString *descriptionInfo;

+ (QJImageModel *)creatModelWithImage:(UIImage *)thumbImage bigUrl:(NSString *)bigUrl description:(NSString *)descriptionInfo;

@end
