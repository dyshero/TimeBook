//
//  LockWallpaperView.h
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import <UIKit/UIKit.h>
 typedef void(^DismissBlock)(void);

@interface LockWallpaperView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic,strong) DismissBlock dismissBlock;
@property (nonatomic,strong) NSTimer *timer;
@end
