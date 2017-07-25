//
//  QJViewController.m
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJViewController.h"

@interface QJViewController ()

@property (nonatomic, strong) UIView *statusView;

@end

@implementation QJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hidesBarsOnSwipe = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //添加监听
    [self.navigationController.navigationBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    if (self.hidesBarsOnSwipe) {
        self.navigationController.hidesBarsOnSwipe = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.statusView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar removeObserver:self forKeyPath:@"hidden" context:nil];
    if (self.hidesBarsOnSwipe) {
        self.navigationController.hidesBarsOnSwipe = NO;
        [self.navigationController setNavigationBarHidden:NO];
        [self.statusView removeFromSuperview];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}

#pragma mark -setter
- (void)setHidesBarsOnSwipe:(BOOL)hidesBarsOnSwipe {
    _hidesBarsOnSwipe = hidesBarsOnSwipe;
    self.navigationController.hidesBarsOnSwipe = _hidesBarsOnSwipe;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth(), 20)];
        _statusView.backgroundColor = AppThemeColor;
    }
    return _statusView;
}

@end
