//
//  QJImageBrowserCell.m
//  Nimingban
//
//  Created by QinJ on 2017/7/7.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJImageBrowserCell.h"
#import "FLAnimatedImageView+WebCache.h"//加载gif
#import "QJImageModel.h"

@interface QJImageBrowserCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, assign) CGFloat beginY;
@property (nonatomic, assign) CGFloat moveY;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation QJImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        //[self addGestureRecognizer:self.pan];
        [self addGestureRecognizer:self.longPress];
    }
    return self;
}

- (void)showImageWithModel:(QJImageModel *)model {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.bigUrl] placeholderImage:model.thumbImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize size = image.size;
        if (size.width < UIScreenWidth() && size.height < UIScreenHeight()) {
            CGRect rect = self.imageView.frame;
            rect.size = size;
            self.imageView.frame = rect;
            self.imageView.center = CGPointMake(UIScreenWidth() / 2, UIScreenHeight() / 2);
            self.scrollView.contentSize = CGSizeMake(self.imageView.frame.origin.x + self.imageView.frame.size.width, self.imageView.frame.origin.y + self.imageView.frame.size.height);
        }
    }];
}

#pragma mark -手势
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
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
    } completion:^(BOOL finished) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(closeVC)]) {
            [self.delegate closeVC];
        }
    }];
}

- (void)backImageWithMoveY:(CGFloat)moveY {
    [UIView animateWithDuration:0.25f animations:^{
        CGRect rect = self.imageView.frame;
        rect.origin.y += moveY;
        self.imageView.frame = rect;
    }];
}

- (void)changeImageFrameWithMoveY:(CGFloat)moveY alpha:(CGFloat)alpha {
    CGRect rect = self.imageView.frame;
    rect.origin.y += moveY;
    self.imageView.frame = rect;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    /*
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
     */
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

#pragma mark -getter
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

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _pan.cancelsTouchesInView = NO;
    }
    return _pan;
}

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _longPress;
}

@end
