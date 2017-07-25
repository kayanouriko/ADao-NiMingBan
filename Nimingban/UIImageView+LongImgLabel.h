//
//  UIImageView+LongImgLabel.h
//  Nimingban
//
//  Created by QinJ on 2017/6/27.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *
    为UIImageView在左下角添加一个长图的水印标签
 */

@interface UIImageView (LongImgLabel)

- (void)addLabel;
- (void)showLabelWithGif:(BOOL)isGif;
- (void)hiddenLabel;

@end
