//
//  WallpaperDetailSetSheetView.m
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallpaperDetailSetSheetView.h"
@interface WallpaperDetailSetSheetView()
@property (weak, nonatomic) IBOutlet UIButton *mainScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *lockScreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation WallpaperDetailSetSheetView

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainScreenBtn.layer.cornerRadius = 5;
    _mainScreenBtn.clipsToBounds = YES;
    
    _lockScreenBtn.layer.cornerRadius = 5;
    _lockScreenBtn.clipsToBounds = YES;
    
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.clipsToBounds = YES;
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (self.setSheetBlock) {
        self.setSheetBlock(sender.tag);
    }
}

@end
