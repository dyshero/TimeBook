//
//  WallpaperDetailSetSheetView.h
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SetSheetBlock)(NSInteger tag);

@interface WallpaperDetailSetSheetView : UIView
@property (nonatomic,strong) SetSheetBlock setSheetBlock;
@end
