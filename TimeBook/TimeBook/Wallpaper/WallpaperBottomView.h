//
//  WallpaperBottomView.h
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WallpaperModel;
typedef void(^BtmClickBlock)(NSInteger tag);

@interface WallpaperBottomView : UIView
@property (nonatomic,weak) WallpaperModel *model;
@property (nonatomic,strong) BtmClickBlock btmClickBlock;
@end
