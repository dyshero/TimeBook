//
//  BaseNavigationController.m
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/1.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;

    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[APPUtils getThemeColor],NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_1]}];
}

@end
