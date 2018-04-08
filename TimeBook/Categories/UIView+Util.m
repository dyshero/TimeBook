//
//  UIView+Util.m
//
//  Created by SKY
//  Copyright © 翊sky. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

- (void)setBorderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setGradientBGColorWithLeftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor {
    self.backgroundColor = [UIColor clearColor];
    
    if ([[self.layer.sublayers lastObject] isKindOfClass:[CAGradientLayer class]]) {
        [[self.layer.sublayers lastObject] removeFromSuperlayer];
    }
    
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)leftColor.CGColor, (__bridge id)rightColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = self.bounds;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    gradientLayer.masksToBounds = YES;
    gradientLayer.zPosition = -1;
    [self.layer addSublayer:gradientLayer];
    
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    self.layer.shadowColor = leftColor.CGColor;
    self.layer.shadowRadius = 6;
    self.layer.shadowOpacity = 0.64;
    self.layer.shadowOffset = CGSizeMake(0, 2);
}

- (void)setGradientBGColorWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    self.backgroundColor = [UIColor clearColor];
    
    if ([[self.layer.sublayers lastObject] isKindOfClass:[CAGradientLayer class]]) {
        [[self.layer.sublayers lastObject] removeFromSuperlayer];
    }
    
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)topColor.CGColor, (__bridge id)bottomColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.frame = self.bounds;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    gradientLayer.masksToBounds = YES;
    gradientLayer.zPosition = -1;
    [self.layer addSublayer:gradientLayer];
}

- (void)setThemeBGColor {
    [self setGradientBGColorWithLeftColor:[APPUtils getThemeLightColor] rightColor:[APPUtils getThemeColor]];
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end
