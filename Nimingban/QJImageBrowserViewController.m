//
//  QJImageBrowserViewController.m
//  Nimingban
//
//  Created by QinJ on 2017/7/7.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJImageBrowserViewController.h"
#import "QJCollectionViewDelegateFlowLayout.h"
#import "QJImageBrowserCell.h"

@interface QJImageBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QJImageBrowserCellDelagate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIView *sayBgView;
@property (nonatomic, strong) UILabel *sayLabel;

@end

@implementation QJImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)setContent {
    self.view.backgroundColor = [UIColor blackColor];
    //collectionview
    [self.view addSubview:self.collectionView];
    //布局
    [self.view addSubview:self.pageLabel];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pageLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_pageLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageLabel)]];
    [self.view addSubview:self.sayBgView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_sayBgView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sayBgView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sayBgView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sayBgView)]];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    //展示3s后隐藏
    [self performSelector:@selector(infoLabelHidden) withObject:nil afterDelay:3.f];
}

#pragma mark -QJImageBrowserCellDelagate
- (void)closeVC {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -手势action
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.pageLabel.alpha) {
        [self infoLabelHidden];
    }
    else {
        [self infoLabelShow];
    }
}

- (void)infoLabelShow {
    if (self.pageLabel.alpha == 0) {
        [UIView animateWithDuration:0.26f animations:^{
            self.pageLabel.alpha = 1;
            self.sayBgView.alpha = 1;
        }];
    }
}

- (void)infoLabelHidden {
    if (self.pageLabel.alpha) {
        [UIView animateWithDuration:0.26f animations:^{
            self.pageLabel.alpha = 0;
            self.sayBgView.alpha = 0;
        }];
    }
}

#pragma mark -collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QJImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([QJImageBrowserCell class]) forIndexPath:indexPath];
    if (!cell.delegate) {
        cell.delegate = self;
    }
    [cell showImageWithModel:self.photos[indexPath.item]];
    return cell;
}

#pragma mark -getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        QJCollectionViewDelegateFlowLayout *layout = [QJCollectionViewDelegateFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[QJImageBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([QJImageBrowserCell class])];
    }
    return _collectionView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.text = @"1 / 10";
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pageLabel;
}

- (UILabel *)sayLabel {
    if (!_sayLabel) {
        _sayLabel = [UILabel new];
        _sayLabel.font = [UIFont systemFontOfSize:14];
        _sayLabel.numberOfLines = 7;
        _sayLabel.text = @"我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述我是描述";
        _sayLabel.textColor = [UIColor whiteColor];
        _sayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _sayLabel;
}

- (UIView *)sayBgView {
    if (!_sayBgView) {
        _sayBgView = [UIView new];
        _sayBgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _sayBgView.translatesAutoresizingMaskIntoConstraints = NO;
        [_sayBgView addSubview:self.sayLabel];
        [_sayBgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_sayLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sayLabel)]];
        [_sayBgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_sayLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sayLabel)]];
    }
    return _sayBgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
