//
//  QJSideContainerController.m
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJSideContainerController.h"
#import "QJSideLeftViewController.h"
#import "ViewController.h"

typedef NS_ENUM(NSInteger, QJSideContainerControllerState) {
    QJSideContainerControllerStateShow,
    QJSideContainerControllerStateHidden,
};

@interface QJSideContainerController ()

@property (nonatomic, assign) CGFloat beginX;
@property (nonatomic, assign) CGFloat changeX;
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;
@property (nonatomic, assign) QJSideContainerControllerState state;

@end

@implementation QJSideContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewController *vc = [ViewController new];
    vc.fatherVC = self;
    self.mainVC = [[UINavigationController alloc] initWithRootViewController:vc];
    self.mainVC.navigationBar.tintColor = [UIColor whiteColor];
    self.mainVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.mainVC.navigationBar.barTintColor = AppThemeColor;
    self.mainVC.navigationBar.translucent = NO;
    
    self.leftVC = [QJSideLeftViewController new];
    self.leftVC.mainVC = vc;
    self.leftVC.fatherVC = self;
    
    [self.view addSubview:self.mainVC.view];
    [self.mainVC.view setFrame:self.view.bounds];
    CALayer *layer = [self.mainVC.view layer];
    layer.borderColor = AppThemeColor.CGColor;
    layer.borderWidth = 0.5f;
    
    [self.view addSubview:self.leftVC.view];
    [self.leftVC.view setFrame:self.view.bounds];
    
    [self.view bringSubviewToFront:self.mainVC.view];
    
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.leftVC.view addGestureRecognizer:pan1];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.beginX = [pan locationInView:self.view].x;
        self.changeX = self.beginX;
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat moveX = [pan locationInView:self.view].x - self.changeX;
        [self changeVCFrameWithMoveX:moveX];
        self.changeX = [pan locationInView:self.view].x;
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if ((self.state == QJSideContainerControllerStateHidden && self.mainVC.view.frame.origin.x > 95) || (self.state == QJSideContainerControllerStateShow && self.mainVC.view.frame.origin.x > 155)) {
            [self showSideView];
        }
        else {
            [self hideSideView];
        }
    }
}

- (void)changeVCFrameWithMoveX:(CGFloat)moveX {
    CGRect rect = self.mainVC.view.frame;
    rect.origin.x += moveX;
    if (rect.origin.x < 0 || rect.origin.x > 250) {
        return;
    }
    self.mainVC.view.frame = rect;
}

- (void)showSideView{
    [self.mainVC.view addGestureRecognizer:self.pan];
    self.state = QJSideContainerControllerStateShow;
    [UIView animateWithDuration:0.25f animations:^{
        CGRect rect = self.mainVC.view.frame;
        rect.origin.x = 250;
        self.mainVC.view.frame = rect;
    }];
}

- (void)hideSideView{
    [self.mainVC.view removeGestureRecognizer:self.pan];
    self.state = QJSideContainerControllerStateHidden;
    [UIView animateWithDuration:0.25f animations:^{
        CGRect rect = self.mainVC.view.frame;
        rect.origin.x = 0;
        self.mainVC.view.frame = rect;
    }];
}

#pragma mark -setter
- (void)setState:(QJSideContainerControllerState)state {
    _state = state;
    if (_state == QJSideContainerControllerStateShow) {
        [self.mainVC.view addSubview:self.touchView];
    }
    else {
        [self.touchView removeFromSuperview];
    }
}

- (void)setCanDragSide:(BOOL)canDragSide {
    _canDragSide = canDragSide;
    if (_canDragSide) {
        [self.mainVC.view addGestureRecognizer:self.edgePan];
    } else {
        [self.mainVC.view removeGestureRecognizer:self.edgePan];
    }
}

#pragma mark -getter
- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSideView)];
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _pan;
}

- (UIScreenEdgePanGestureRecognizer *)edgePan {
    if (!_edgePan) {
        _edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showSideView)];
        _edgePan.edges = UIRectEdgeLeft;
    }
    return _edgePan;
}

- (UIView *)touchView {
    if (!_touchView) {
        _touchView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _touchView.backgroundColor = [UIColor clearColor];
        [_touchView addGestureRecognizer:self.tap];
    }
    return _touchView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];}

@end
