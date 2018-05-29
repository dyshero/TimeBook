//
//  WallpaperDetailController.m
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallpaperDetailController.h"
#import "WallpaperModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "WallpaperBottomView.h"
#import "LockWallpaperView.h"
#import "WallpaperDetailSetSheetView.h"
#import "MainScreenWallpaperView.h"
#import "UIImageView+Util.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define BtmTitleH 50

@interface WallpaperDetailController ()
@property (nonatomic,strong) UIImageView *wallpaperImageView;
@property (nonatomic,strong) WallpaperBottomView *bottomView;
@property (nonatomic,assign) CGFloat btmH;
@property (nonatomic,assign) CGFloat btmOffset;
@property (nonatomic,strong) LockWallpaperView *lockWallPaperView;
@property (nonatomic,strong) WallpaperDetailSetSheetView *setSheetView;
@property (nonatomic,strong) MainScreenWallpaperView *mainWallpaperView;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation WallpaperDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    _wallpaperImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_wallpaperImageView];
    
    [self.view addSubview:self.bottomView];
    _btmH = 330 - 17 + [_model.content heightForFont:[UIFont systemFontOfSize:14] width:WIDTH-30];
    self.bottomView.frame = CGRectMake(0, HEIGHT - BtmTitleH - SafeAreaBottom, WIDTH, _btmH);
    
    __weak typeof(self) ws = self;
    if (IsX == NO) {
        [_wallpaperImageView loadProgressImageWithUrl:_model.cover_hd_568h complete:^{
            [ws.bottomView changeEnble];
        }];
    } else {
        if (_model.cover_hd_812h) {
            [_wallpaperImageView loadProgressImageWithUrl:_model.cover_hd_812h complete:^{
                [ws.bottomView changeEnble];
            }];
        } else {
            [_wallpaperImageView loadProgressImageWithUrl:_model.cover_hd_568h complete:^{
                [ws.bottomView changeEnble];
            }];
        }
    }
    
    self.view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panReg = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealPan:)];
    [self.view addGestureRecognizer:panReg];
}

- (void)dealPan:(UIPanGestureRecognizer *)reg {
    CGPoint point = [reg translationInView:self.view];
    CGFloat y = point.y;
    
    if (_btmOffset == 0 && y > 0) {
        return;
    }
    
    _btmOffset -= y;
    if (y < 0) {
        if (_btmOffset + 50 >= _btmH/3) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bottomView.frame = CGRectMake(0, HEIGHT - _btmH, WIDTH, _btmH);
            } completion:^(BOOL finished) {
                _btmOffset = _btmH - 50;
            }];
        } else {
            self.bottomView.frame = CGRectMake(0, HEIGHT - _btmOffset - BtmTitleH - SafeAreaBottom, WIDTH, _btmH);
        }
    } else {
        if (_btmOffset + 50 <= _btmH/3) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bottomView.frame = CGRectMake(0, HEIGHT - BtmTitleH - SafeAreaBottom, WIDTH, _btmH);
            } completion:^(BOOL finished) {
                _btmOffset = 0;
            }];
        } else {
            self.bottomView.frame = CGRectMake(0, HEIGHT - _btmOffset - BtmTitleH - SafeAreaBottom, WIDTH, _btmH);
        }
    }
}

- (WallpaperBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [WallpaperBottomView nibInitializtion];
        _bottomView.model = _model;
        
        __weak typeof(self) ws = self;
        _bottomView.btmClickBlock = ^(NSInteger tag) {
            if (tag == 1) {
                [ws.navigationController popViewControllerAnimated:YES];
            } else if (tag == 2) {
                UIImageWriteToSavedPhotosAlbum(ws.wallpaperImageView.image, ws, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)ws);
            } else if (tag == 3) {
                NSURL *url = [NSURL URLWithString:@"https://github.com/dyshero"];
                UIImage *image = [UIImage imageNamed:@"shareLogo"];
                NSString *str = ws.model.title_wechat;
                NSArray *activityItems = @[str,image,url];
                UIActivityViewController *activityViewController =
                [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                [ws presentViewController:activityViewController animated:YES completion:nil];
                [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                    if (completed) {
                        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                    }
                }];
            } else {
                [ws.view addSubview:ws.bgView];
                [ws.view addSubview:ws.setSheetView];
                [UIView animateWithDuration:0.3 animations:^{
                    ws.setSheetView.frame = CGRectMake(0, HEIGHT - 170, WIDTH, 170);
                }];
            }
        };
    }
    return _bottomView;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
}

- (LockWallpaperView *)lockWallPaperView {
    if (!_lockWallPaperView) {
        _lockWallPaperView = [LockWallpaperView nibInitializtion];
        _lockWallPaperView.frame = [UIScreen mainScreen].bounds;
        _lockWallPaperView.bgImageView.image = _wallpaperImageView.image;
        _lockWallPaperView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [_lockWallPaperView removeFromSuperview];
            _lockWallPaperView = nil;
        }];
        [_lockWallPaperView addGestureRecognizer:tap];

        __weak typeof(self) ws = self;
        _lockWallPaperView.dismissBlock = ^{
            [ws.lockWallPaperView.timer invalidate];
            ws.lockWallPaperView.timer = nil;
            [ws.lockWallPaperView removeFromSuperview];
            ws.lockWallPaperView = nil;
        };
    }
    return _lockWallPaperView;
}

- (WallpaperDetailSetSheetView *)setSheetView {
    if (!_setSheetView) {
        _setSheetView = [WallpaperDetailSetSheetView nibInitializtion];
        _setSheetView.frame = CGRectMake(0, HEIGHT, WIDTH, 170);
        __weak typeof(self) ws = self;
        _setSheetView.setSheetBlock = ^(NSInteger tag) {
            [UIView animateWithDuration:0.3 animations:^{
                ws.setSheetView.frame = CGRectMake(0, HEIGHT, WIDTH, 170);
            } completion:^(BOOL finished) {
                [ws.setSheetView removeFromSuperview];
                ws.setSheetView = nil;
                [ws.bgView removeFromSuperview];
                ws.bgView = nil;
                
                if (tag == 1) {
                    [ws.view addSubview:ws.mainWallpaperView];
                } else if (tag == 2) {
                    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)];
                    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
                    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
                    
                    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    showViewAnn.fromValue = [NSNumber numberWithFloat:0.0];
                    showViewAnn.toValue = [NSNumber numberWithFloat:1.0];
                    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    
                    CAAnimationGroup *group = [CAAnimationGroup animation];
                    group.duration = 0.3;
                    group.removedOnCompletion = NO;
                    group.repeatCount = 1;
                    group.fillMode = kCAFillModeForwards;
                    [group setAnimations:@[scaleAnimation,showViewAnn]];
                    [ws.view.layer addAnimation:group forKey:@"group"];
                    [ws.view addSubview:ws.lockWallPaperView];
                }

            }];
        };
    }
    return _setSheetView;
}

- (MainScreenWallpaperView *)mainWallpaperView {
    if (!_mainWallpaperView) {
        _mainWallpaperView = [MainScreenWallpaperView nibInitializtion];
        _mainWallpaperView.frame = [UIScreen mainScreen].bounds;
        _mainWallpaperView.userInteractionEnabled = YES;
        _mainWallpaperView.bgImageView.image = _wallpaperImageView.image;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [_mainWallpaperView removeFromSuperview];
            _mainWallpaperView = nil;
        }];
        [_mainWallpaperView addGestureRecognizer:tap];
    }
    return _mainWallpaperView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return _bgView;
}

- (void)dealloc {
    
}
@end
