//
//  WallpaperCell.h
//  TimeBook
//
//  Created by CarMayor on 2017/12/9.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "WallpaperModel.h"

@interface WallpaperCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (nonatomic,strong) WallpaperModel *model;

@property (nonatomic,assign) BOOL isLeft;

@end
