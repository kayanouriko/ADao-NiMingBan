//
//  NSString+CustomCatgory.h
//  Nimingban
//
//  Created by QinJ on 2017/6/30.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CustomCatgory)

//计算字符串的宽度
- (CGFloat)StringWidthWithFontSize:(UIFont *)font;
//换算时间成我想要的
- (NSString *)dateWithDateString;

@end
