//
//  NSString+CustomCatgory.m
//  Nimingban
//
//  Created by QinJ on 2017/6/30.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "NSString+CustomCatgory.h"

@implementation NSString (CustomCatgory)

- (CGFloat)StringWidthWithFontSize:(UIFont *)font {
    UIFont *strFont = font;
    if (nil == strFont) {
        strFont = [UIFont systemFontOfSize:14.f];
    }
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:strFont} context:nil].size.width;
}

- (NSString *)dateWithDateString {
    //2017-04-01(六)00:16:55
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd(EEE)HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self];
    
    return [self transTime:[date timeIntervalSince1970]];
}

- (NSString *)transTime:(NSTimeInterval)createTime {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    if (time < 61) {
        return @"刚刚";
    }
    //秒转分钟
    NSInteger minute = time / 60;
    if (minute < 61) {
        return [NSString stringWithFormat:@"%ld分钟前",minute];
    }
    //秒转小时
    NSInteger hours = time/3600;
    if (hours < 25) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 32) {
        dateFormatter.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"%ld天前 %@",days ,[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 13) {
        dateFormatter.dateFormat = @"MM-dd HH:mm";
        return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    }
    //年
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
}

@end
