//
//  UIButton+Util.m
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/2.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "UIButton+Util.h"

@implementation UIButton (Util)

//image,title
+(UIButton *)buttonWithLocalImage:(NSString *)image
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                         fontSize:(CGFloat)fontSize
                            frame:(CGRect)frame
                            click:(void (^)())clickBlock {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (image.length > 0) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    if (titleColor != nil) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }

    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    return btn;
}

//image
+(UIButton *)buttonWithLocalImage:(NSString *)image
                            frame:(CGRect)frame
                            click:(void (^)())clickBlock {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (image.length > 0) {
        UIImage *btnImage = [UIImage imageNamed:image];
        [btn setImage:btnImage forState:UIControlStateNormal];
    }
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    return btn;
    
}

//backgroundImage
+(UIButton *)buttonWithLocalBgImage:(NSString *)bgImage
                              frame:(CGRect)frame
                              click:(void (^)())clickBlock {

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (bgImage.length > 0) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    }
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    return btn;
    
}

+(UIButton *)buttonWithNetImage:(NSString *)imageURL
                          title:(NSString *)title
                     titleColor:(UIColor *)titleColor
                       fontSize:(CGFloat)fontSize
                          frame:(CGRect)frame
                          click:(void (^)())clickBlock {

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (imageURL.length > 0) {
        [btn buttonWithNetImage:imageURL];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    if (titleColor != nil) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    return btn;
}

+(UIButton *)buttonWithNetImage:(NSString *)imageURL
                          frame:(CGRect)frame
                          click:(void (^)())clickBlock {

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (imageURL.length > 0) {
        [btn buttonWithNetImage:imageURL];
    }
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    return btn;
}

//backgroundImage
+(UIButton *)buttonWithNetBgImage:(NSString *)bgImageURL
                            frame:(CGRect)frame
                            click:(void (^)())clickBlock {

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (bgImageURL.length > 0) {
        [btn buttonWithNetBGImage:bgImageURL];
    }
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    return btn;
    
}

-(void)buttonWithNetImage:(NSString *)netImageURL{
    
    NSURL *url = [NSURL URLWithString:netImageURL];

    [self setImageWithURL:url
                 forState:UIControlStateNormal
              placeholder:nil
                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    }
                transform:nil
               completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
}

-(void)buttonWithNetBGImage:(NSString *)netBGImageURL{
    
    NSURL *url = [NSURL URLWithString:netBGImageURL];
    [self setBackgroundImageWithURL:url
                           forState:UIControlStateNormal
                        placeholder:nil
                            options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    }
                          transform:nil
                         completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
}

@end
