//
//  UIImageView+Util.m
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/2.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "UIImageView+Util.h"
#import "DDCircleProgressView.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Util)

+ (UIImageView *)imageViewWithLocalImage:(NSString *)image frame:(CGRect)frame {
    
    YYAnimatedImageView *picture = [[YYAnimatedImageView alloc] initWithFrame:frame];
    picture.image = [UIImage imageNamed:image];
    return picture;
}

+ (UIImageView *)imageViewWithNetImage:(NSString *)imgURL frame:(CGRect)frame {
    
    YYAnimatedImageView *picture = [[YYAnimatedImageView alloc] initWithFrame:frame];
    picture.clipsToBounds = YES;
    picture.contentMode = UIViewContentModeScaleAspectFill;
    [picture setImageWithURL:[NSURL URLWithString:imgURL] placeholder:[UIImage imageNamed:DEFAULT_BG]];
    
    return picture;
}

- (void)loadWithImgUrl:(NSString *)imgURL complete:(void (^)())complete {
    
    self.backgroundColor = COLOR_NULL_7;

    UIImageView *gifPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 70)];
    gifPic.center = self.center;
    [self addSubview:gifPic];
    
    NSMutableArray *gifImages = [NSMutableArray array];
    for (NSInteger i = 0; i < 33; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"load%02ld.png",i + 1]];
        [gifImages addObject:image];
    }
    gifPic.animationImages = gifImages;
    gifPic.animationDuration = 3.2;
    gifPic.animationRepeatCount = 0;
    [gifPic startAnimating];
    
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:[NSURL URLWithString:imgURL] placeholder:nil options:YYWebImageOptionIgnoreFailedURL completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        [gifPic removeFromSuperview];
        
        if (image) {
            weakSelf.image = image;
        }else {
            weakSelf.image = [UIImage imageNamed:DEFAULT_FAIL_BG];
        }
        
        if (complete) {
            complete();
        }
    }];
}

- (void)loadProgressImageWithUrl:(NSString *)imgUrl complete:(void (^)())complete {
    __block DDCircleProgressView *progressView = [[DDCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    progressView.center = self.center;
    [self addSubview:progressView];
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress = receivedSize/(expectedSize*1.0);
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [progressView removeFromSuperview];
        progressView = nil;
        weakSelf.image = image;
        if (complete) {
            complete();
        }
    }];
}

@end
