//
//  LaunchView.m
//  CarMayor
//
//  Created by CarMayor on 17/5/27.
//  Copyright © 2017年 SKY. All rights reserved.
//

#import "LaunchView.h"

@interface LaunchView ()

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *centerHView;
@property (weak, nonatomic) IBOutlet UIView *centerVView;

@property (weak, nonatomic) IBOutlet UILabel *oLabel;
@property (weak, nonatomic) IBOutlet UILabel *dLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *o_left;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *d_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *a_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *y_top;

@end

@implementation LaunchView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.centerHView setThemeBGColor];
    [self.centerVView setThemeBGColor];
    self.centerHView.alpha = self.centerVView.alpha = 0.72;
    
    self.oLabel.textColor = self.dLabel.textColor = self.aLabel.textColor = self.yLabel.textColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.72];
    
    self.oLabel.alpha = self.dLabel.alpha = self.aLabel.alpha = self.yLabel.alpha = 0.f;
}

+ (void)show {
    
    LaunchView *launchView = [LaunchView nibInitializtion];
    launchView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:launchView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(- WIDTH * 0.64, HEIGHT * 0.24, WIDTH * 0.64, 1)];
    line1.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];
    [launchView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(- WIDTH * 0.64, HEIGHT * 0.72, WIDTH * 0.64, 1)];
    line2.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.36];
    [launchView addSubview:line2];
    
    [UIView animateWithDuration:1.2 delay:0.48 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        line1.left = WIDTH;
    } completion:^(BOOL finished) {
        [line1 removeFromSuperview];
    }];
    
    [UIView animateWithDuration:1.2 delay:0.96 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        line2.left = WIDTH;
    } completion:^(BOOL finished) {
        [line2 removeFromSuperview];
    }];

    launchView.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    [UIView animateWithDuration:1.6 animations:^{
        launchView.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        
        launchView.o_left.constant = 16;
        [UIView animateWithDuration:0.48 delay:0.f usingSpringWithDamping:0.5f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [launchView layoutIfNeeded];
            launchView.oLabel.alpha = 1.f;
        } completion:^(BOOL finished) {
            
            launchView.d_top.constant = 32 + 2;
            [UIView animateWithDuration:0.36 delay:0.f usingSpringWithDamping:0.5f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [launchView layoutIfNeeded];
                launchView.dLabel.alpha = 1.f;
            } completion:^(BOOL finished) {
                
                launchView.a_top.constant = (32 + 2) * 2;
                [UIView animateWithDuration:0.36 delay:0.f usingSpringWithDamping:0.5f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [launchView layoutIfNeeded];
                    launchView.aLabel.alpha = 1.f;
                } completion:^(BOOL finished) {
                    
                    launchView.y_top.constant = (32 + 2) * 3;
                    [UIView animateWithDuration:0.36 delay:0.f usingSpringWithDamping:0.5f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [launchView layoutIfNeeded];
                        launchView.yLabel.alpha = 1.f;
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:0.36 delay:2.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            launchView.alpha = 0.f;
                        } completion:^(BOOL finished) {
                            [launchView removeFromSuperview];
                        }];
                    }];
                }];
            }];
        }];
        
    }];
    
}

@end
