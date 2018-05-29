//
//  WallpaperCell.m
//  TimeBook
//
//  Created by duodian on 2018/5/11.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallpaperCell.h"
#import "WallpaperModel.h"
@interface WallpaperCell()
@property (weak, nonatomic) IBOutlet UIImageView *wallImageView;
@end

@implementation WallpaperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _wallImageView.layer.cornerRadius = 5;
    _wallImageView.clipsToBounds = YES;
}

- (void)setModel:(WallpaperModel *)model {
    [_wallImageView setImageURL:[NSURL URLWithString:model.thumb]];
}
@end
