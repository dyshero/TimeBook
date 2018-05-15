//
//  MainScreenWallpaperView.m
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "MainScreenWallpaperView.h"
@interface MainScreenWallpaperView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation MainScreenWallpaperView

- (void)awakeFromNib {
    [super awakeFromNib];
    _topImageViewConstraint.constant = NAVBAR_HEIGHT - STATUEBAR_HEIGHT;
    if (IsX) {
_bottomView.layer.cornerRadius = 20;
        _bottomView.clipsToBounds = YES;
    }
}
@end
