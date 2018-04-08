//
//  UIButton+Util.h
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/2.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Util)

+(UIButton *)buttonWithLocalImage:(NSString *)image
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                         fontSize:(CGFloat)fontSize
                            frame:(CGRect)frame
                            click:(void (^)())clickBlock;

+(UIButton *)buttonWithLocalImage:(NSString *)image
                            frame:(CGRect)frame
                            click:(void (^)())clickBlock;


+(UIButton *)buttonWithLocalBgImage:(NSString *)bgImage
                              frame:(CGRect)frame
                              click:(void (^)())clickBlock;


+(UIButton *)buttonWithNetImage:(NSString *)imageURL
                          title:(NSString *)title
                     titleColor:(UIColor *)titleColor
                       fontSize:(CGFloat)fontSize
                          frame:(CGRect)frame
                          click:(void (^)())clickBlock;


+(UIButton *)buttonWithNetImage:(NSString *)imageURL
                          frame:(CGRect)frame
                          click:(void (^)())clickBlock;


+(UIButton *)buttonWithNetBgImage:(NSString *)bgImageURL
                            frame:(CGRect)frame
                            click:(void (^)())clickBlock;

@end
