//
//  ThemeColorView.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/11.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "ThemeColorView.h"

@interface ThemeColorView ()

@property (weak, nonatomic) IBOutlet UIView *colorBGView1;
@property (weak, nonatomic) IBOutlet UIView *colorBGView2;
@property (weak, nonatomic) IBOutlet UIView *colorBGView3;
@property (weak, nonatomic) IBOutlet UIView *colorBGView4;
@property (weak, nonatomic) IBOutlet UIView *colorBGView5;
@property (weak, nonatomic) IBOutlet UIView *colorBGView6;

@property (weak, nonatomic) IBOutlet UIView *colorView1;
@property (weak, nonatomic) IBOutlet UIView *colorView2;
@property (weak, nonatomic) IBOutlet UIView *colorView3;
@property (weak, nonatomic) IBOutlet UIView *colorView4;
@property (weak, nonatomic) IBOutlet UIView *colorView5;
@property (weak, nonatomic) IBOutlet UIView *colorView6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorView1_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorView2_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorView3_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorView4_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorView5_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorView6_bottom;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtn_bottom;

@end

@implementation ThemeColorView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.closeBtn setCornerRadius:self.closeBtn.height * 0.5];
    self.closeBtn.backgroundColor = [UIColor whiteColor];
    
    self.colorView1_bottom.constant = - self.colorView1.height - 24;
    self.colorView2_bottom.constant = - self.colorView2.height - 24;
    self.colorView3_bottom.constant = - self.colorView3.height - 24;
    self.colorView4_bottom.constant = - self.colorView4.height - 24;
    self.colorView5_bottom.constant = - self.colorView5.height - 24;
    self.colorView6_bottom.constant = - self.colorView6.height - 24;

    self.closeBtn_bottom.constant = - self.closeBtn.height;
    
    [self layoutIfNeeded];
    
    self.colorBGView1.backgroundColor = self.colorBGView2.backgroundColor = self.colorBGView3.backgroundColor = self.colorBGView4.backgroundColor = self.colorBGView5.backgroundColor = self.colorBGView6.backgroundColor = COLOR_NULL_7;
    
    [self.colorView1 setGradientBGColorWithLeftColor:COLOR_1_LIGHT rightColor:COLOR_1];
    [self.colorView2 setGradientBGColorWithLeftColor:COLOR_2_LIGHT rightColor:COLOR_2];
    [self.colorView3 setGradientBGColorWithLeftColor:COLOR_3_LIGHT rightColor:COLOR_3];
    [self.colorView4 setGradientBGColorWithLeftColor:COLOR_4_LIGHT rightColor:COLOR_4];
    [self.colorView5 setGradientBGColorWithLeftColor:COLOR_5_LIGHT rightColor:COLOR_5];
    [self.colorView6 setGradientBGColorWithLeftColor:COLOR_6_LIGHT rightColor:COLOR_6];
    
    self.colorView1.alpha = self.colorView2.alpha = self.colorView3.alpha = self.colorView4.alpha = self.colorView5.alpha = self.colorView6.alpha = 0.84;
    
    NSArray *arr = @[self.colorView1,self.colorView2,self.colorView3,self.colorView4,self.colorView5,self.colorView6];
    for (int index = 0; index < arr.count; index ++) {
        UIView *view = arr[index];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            [self hide];
            [APPUtils setColorAtIndex:index];
            
        }]];
    }
}

+ (void)show {

    ThemeColorView *themeColorView = [ThemeColorView nibInitializtion];
    themeColorView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:themeColorView];
    
    [themeColorView show];
}

- (void)show {
    
    self.hidden = NO;
    [UIView animateWithDuration:0.36 animations:^{
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.84];
    } completion:^(BOOL finished) {
        
        [self colorViewAnimationWithDis:320 bottom:self.colorView1_bottom showIndex:0];
        [self colorViewAnimationWithDis:320 bottom:self.colorView2_bottom showIndex:1];
        [self colorViewAnimationWithDis:320 bottom:self.colorView3_bottom showIndex:2];
        [self colorViewAnimationWithDis:196 bottom:self.colorView4_bottom showIndex:3];
        [self colorViewAnimationWithDis:196 bottom:self.colorView5_bottom showIndex:4];
        [self colorViewAnimationWithDis:196 bottom:self.colorView6_bottom showIndex:5];
        
        self.closeBtn.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        self.closeBtn_bottom.constant = 64;
        [UIView animateWithDuration:0.48 delay:0.64 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
            self.closeBtn.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)hide {
    
    self.closeBtn_bottom.constant = - self.closeBtn.height;
    [UIView animateWithDuration:0.36 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self colorViewAnimationWithDis:- self.colorView6.height - 24 bottom:self.colorView6_bottom showIndex:0];
        [self colorViewAnimationWithDis:- self.colorView5.height - 24 bottom:self.colorView5_bottom showIndex:1];
        [self colorViewAnimationWithDis:- self.colorView4.height - 24 bottom:self.colorView4_bottom showIndex:2];
        [self colorViewAnimationWithDis:- self.colorView3.height - 24 bottom:self.colorView3_bottom showIndex:3];
        [self colorViewAnimationWithDis:- self.colorView2.height - 24 bottom:self.colorView2_bottom showIndex:4];
        [self colorViewAnimationWithDis:- self.colorView1.height - 24 bottom:self.colorView1_bottom showIndex:5];
        
        [UIView animateWithDuration:0.36 delay:0.64 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }];
}

- (void)colorViewAnimationWithDis:(CGFloat)dis bottom:(NSLayoutConstraint *)bottom showIndex:(int)index {
    
    bottom.constant = dis;
    [UIView animateWithDuration:0.72 delay:0.08f * index usingSpringWithDamping:0.72f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (IBAction)close:(id)sender {
    [self hide];
}

@end
