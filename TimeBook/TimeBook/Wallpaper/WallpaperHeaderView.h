//
//  WallpaperHeaderView.h
//  TimeBook
//
//  Created by duodian on 2018/5/11.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WallPaperCategoryModel;

@interface WallpaperHeaderView : UICollectionReusableView
@property (nonatomic,weak) WallPaperCategoryModel *model;
@end
