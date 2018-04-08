//
//  ScrollViewHeader.m
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/18.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "ScrollViewHeader.h"

@implementation ScrollViewHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.stateLabel.hidden = YES;

    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 0; i < 33; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"load%02ld.png",i + 1]];
        [refreshingImages addObject:image];
    }

    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.automaticallyChangeAlpha = YES;
}
@end
