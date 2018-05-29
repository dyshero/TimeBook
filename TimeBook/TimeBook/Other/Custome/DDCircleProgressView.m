//
//  DDCircleProgressView.m
//  TimeBook
//
//  Created by duodian on 2018/5/16.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "DDCircleProgressView.h"

#define KHWCircleLineWidth 5.0f
#define KHWCircleFont [UIFont boldSystemFontOfSize:26.0f]
#define KHWCircleColor [APPUtils getThemeColor]

@interface DDCircleProgressView ()
@property (nonatomic, weak) UILabel *cLabel;
@end

@implementation DDCircleProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //百分比标签
        UILabel *cLabel = [[UILabel alloc] initWithFrame:self.bounds];
        cLabel.font = KHWCircleFont;
        cLabel.textColor = KHWCircleColor;
        cLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cLabel];
        self.cLabel = cLabel;
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    _cLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //线宽
    path.lineWidth = KHWCircleLineWidth;
    //颜色
    [KHWCircleColor set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - KHWCircleLineWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [path stroke];
}
@end
