//
//  QJBigImageShowView.m
//  Nimingban
//
//  Created by QinJ on 2017/6/29.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJBigImageShowView.h"
#import "SDWebImageManager.h"
#import "UIImage+GIF.h"
#import "FLAnimatedImageView+WebCache.h"//加载gif

@interface QJBigImageShowView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, assign) CGFloat beginY;
@property (nonatomic, assign) CGFloat moveY;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation QJBigImageShowView {
    UIScrollView *_scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        [self addSubview:self.scrollView];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tap];
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.pan];
        [self addGestureRecognizer:self.longPress];
        [self.tap requireGestureRecognizerToFail:self.doubleTap];
    }
    return self;
}

+ (void)showBrowerWithThumb:(UIImage *)image bigImageUrl:(NSString *)url withContrller:(UIViewController *)controller {
    QJBigImageShowView *brower = [[QJBigImageShowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    brower.alpha = 0;
    brower.vc = controller;
    //重新设置scrollview的contentSize大小和image的frame大小
    /*
    CGSize size = image.size;
    CGFloat height = UIScreenWidth() * size.height / size.width;
    if (height > UIScreenHeight()) {
        brower.imageView.frame = CGRectMake(0, 0, UIScreenWidth(), height);
        brower.scrollView.contentSize = CGSizeMake(UIScreenWidth(), height);
    }
    */
    [brower.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize size = image.size;
        if (size.width < UIScreenWidth() && size.height < UIScreenHeight()) {
            CGRect rect = brower.imageView.frame;
            rect.size = size;
            brower.imageView.frame = rect;
            brower.imageView.center = CGPointMake(UIScreenWidth() / 2, UIScreenHeight() / 2);
            brower.scrollView.contentSize = CGSizeMake(brower.imageView.frame.origin.x + brower.imageView.frame.size.width, brower.imageView.frame.origin.y + brower.imageView.frame.size.height);
        }
        [QJToast showWithTip:@"图片加载完毕!"];
    }];
    [brower show];
}

- (void)show {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    [windows addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
    }];
}

- (void)closeWithWay:(BOOL)isUp {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    CGRect rect = self.imageView.frame;
    if (isUp) {
        rect.origin.y = -UIScreenHeight();
    } else {
        rect.origin.y = UIScreenHeight();
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.imageView.frame = rect;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -pan手势
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat moveY = [pan locationInView:self].y;
        CGFloat alpha = 1 - fabs(moveY - self.beginY) / UIScreenHeight();
        [self changeImageFrameWithMoveY:moveY - self.moveY alpha:alpha];
        self.moveY = moveY;
    }
    else if (pan.state == UIGestureRecognizerStateBegan) {
        self.beginY = [pan locationInView:self].y;
        self.moveY = self.beginY;
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat moveY = [pan locationInView:self].y;
        
        if (moveY - self.beginY > UIScreenHeight() / 5 || moveY - self.beginY < -UIScreenHeight() / 5) {
            [self closeWithWay:moveY - self.beginY < -UIScreenHeight() / 5];
        } else {
            [self backImageWithMoveY:self.beginY - moveY];
        }
    }
}

- (void)backImageWithMoveY:(CGFloat)moveY {
    [UIView animateWithDuration:0.25f animations:^{
        CGRect rect = self.imageView.frame;
        rect.origin.y += moveY;
        self.imageView.frame = rect;
        self.bgView.alpha = 1;
    }];
}

- (void)changeImageFrameWithMoveY:(CGFloat)moveY alpha:(CGFloat)alpha {
    CGRect rect = self.imageView.frame;
    rect.origin.y += moveY;
    self.imageView.frame = rect;
    self.bgView.alpha = alpha < 0 ? 0 : alpha;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self closeWithWay:NO];
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale == 1.f) {
        [self.scrollView setZoomScale:2.f animated:YES];
    }
    else {
        [self.scrollView setZoomScale:1.f animated:YES];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择操作" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }];
        [alert addAction:saveAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        
        [self.vc presentViewController:alert animated:YES completion:nil];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [QJToast showWithTip:@"图片保存失败,请重新尝试保存!"];
    } else {
        [QJToast showWithTip:@"图片保存成功!"];
    }
}

#pragma mark -UIScrollViewDelegat
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //干掉黑边浮动
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = 0;
    imageViewFrame.origin.y = 0;
    if (imageViewFrame.size.height < self.frame.size.height) {
        imageViewFrame.origin.y = (self.frame.size.height - imageViewFrame.size.height)/2;
    }
    if (imageViewFrame.size.width < self.frame.size.width) {
        imageViewFrame.origin.x = (self.frame.size.width - imageViewFrame.size.width)/2;
    }
    self.imageView.frame = imageViewFrame;
}

/*
//所有缩放动画结束后响应
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if (scale == 1) {
        [self addGestureRecognizer:self.pan];
    }
    else {
        [self removeGestureRecognizer:self.pan];
    }
}
*/

#pragma mark -getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
    }
    return _bgView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = [UIScreen mainScreen].bounds.size;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.decelerationRate = 0.1f;//降低移动速度
        [_scrollView addSubview:self.imageView];
    }
    return _scrollView;
}

- (FLAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _pan;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _longPress;
}

@end
