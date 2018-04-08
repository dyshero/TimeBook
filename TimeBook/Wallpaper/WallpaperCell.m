//
//  WallpaperCell.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/9.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "WallpaperCell.h"

#import "NSString+Util.h"

@interface WallpaperCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabel_width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;

@end

@implementation WallpaperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self reloadThemeColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadThemeColor) name:@"change_theme_color" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadThemeColor{
    self.picture.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.08];
    self.dateLabel.backgroundColor = [[APPUtils getThemeColor] colorWithAlphaComponent:0.24];
}

- (void)setModel:(WallpaperModel *)model {
    _model = model;
    
    [self.picture setImageURL:[NSURL URLWithString:model.ios_wallpaper_url]];
    self.dateLabel.text = [model.publish_date day];
    
    self.dateLabel_width.constant = 0;
    [self layoutIfNeeded];

    self.dateLabel_width.constant = 48;
    [UIView animateWithDuration:0.48 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)setIsLeft:(BOOL)isLeft {
    _isLeft = isLeft;
    
    if (isLeft) {
        self.left.constant = 8;
        self.right.constant = 0;
    }else {
        self.left.constant = 0;
        self.right.constant = 8;
    }
}

@end
