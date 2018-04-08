//
//  UIView+Util.h
//
//  Created by SKY
//  Copyright © 翊sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

- (void)setBorderWidth:(CGFloat)width borderColor:(UIColor *)color;
- (void)setCornerRadius:(CGFloat)cornerRadius;

- (void)setGradientBGColorWithLeftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor;
- (void)setGradientBGColorWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

- (void)setThemeBGColor;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

@end
