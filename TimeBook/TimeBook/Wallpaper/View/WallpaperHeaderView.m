//
//  WallpaperHeaderView.m
//  TimeBook
//
//  Created by duodian on 2018/5/11.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallpaperHeaderView.h"
#import "WallPaperCategoryModel.h"
@interface WallpaperHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@end

@implementation WallpaperHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(WallPaperCategoryModel *)model {
    _topLabel.text = model.title;
    _bottomLabel.text = model.name;
}
@end
