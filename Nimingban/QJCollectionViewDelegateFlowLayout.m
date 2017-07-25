//
//  QJCollectionViewDelegateFlowLayout.m
//  Nimingban
//
//  Created by QinJ on 2017/7/7.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJCollectionViewDelegateFlowLayout.h"

@implementation QJCollectionViewDelegateFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    //初始化
    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
}

@end
