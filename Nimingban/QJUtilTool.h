//
//  QJUtilTool.h
//  Nimingban
//
//  Created by QinJ on 2017/7/3.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SysUABlock)(BOOL isChange);

@interface QJUtilTool : NSObject

+ (QJUtilTool *)shareTool;

- (void)changeSystemUAWithBlock:(SysUABlock)block;

@end
