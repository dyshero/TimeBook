//
//  UIScrollView+Util.m
//  CarMayor
//
//  Created by CarMayor on 17/5/2.
//  Copyright © 2017年 SKY. All rights reserved.
//

#import "UIScrollView+Util.h"

#import <MJRefresh.h>

@implementation UIScrollView (Util)

- (void)showError:(NSString *)errorDesc {
    
    static BOOL isAnimationing = NO;
    
    if (isAnimationing || self.mj_header) {
        return;
    }
    
    isAnimationing = YES;
    UIEdgeInsets edgeInsets = self.contentInset;
    
    UIButton *errorbtn = [UIButton buttonWithLocalImage:@"alert_error.png" title:[NSString stringWithFormat:@" %@",errorDesc] titleColor:ColorHex(@"ff4634") fontSize:FONT_SIZE_3 frame:CGRectMake(0, -edgeInsets.top - 36, self.contentSize.width, 36) click:nil];
    errorbtn.backgroundColor = ColorHex(@"fef6e6");
    
    [self addSubview:errorbtn];
    
    [self scrollToTop];
    
    [UIView animateWithDuration:0.36 animations:^{

        self.contentInset = UIEdgeInsetsMake(edgeInsets.top + errorbtn.height, edgeInsets.left, edgeInsets.bottom, edgeInsets.right);
        
    } completion:^(BOOL finished) {
        [self scrollToTop];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.36 animations:^{
                
                self.contentInset = edgeInsets;
                
            } completion:^(BOOL finished) {
                
                [errorbtn removeFromSuperview];
                isAnimationing = NO;
                
            }];
            
        });
    }];
    
}

@end
