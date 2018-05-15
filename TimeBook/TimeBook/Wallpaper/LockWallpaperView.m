//
//  LockWallpaperView.m
//  TimeBook
//
//  Created by duodian on 2018/5/14.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "LockWallpaperView.h"
@interface LockWallpaperView()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *btmLabel;
@property (nonatomic,strong) NSArray * weekArray;
@end

@implementation LockWallpaperView

- (void)awakeFromNib {
    [super awakeFromNib];
    _weekArray = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    [self timeChange];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timeChange {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents * cmp = [calender components:NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour  fromDate:[NSDate date]];
    _topLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",cmp.hour,cmp.minute];
    _btmLabel.text = [NSString stringWithFormat:@"%ld月%ld日 %@",cmp.month,cmp.day,_weekArray[cmp.weekday-1]];
}

- (IBAction)dismissClicked:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
