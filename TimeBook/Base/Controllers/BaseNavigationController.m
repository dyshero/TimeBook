//
//  BaseNavigationController.m
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/1.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController () <UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [viewController.navigationController setNavigationBarHidden:NO];
    
    NSArray *hiddenNavCtrs = @[@"RecommendArticleDetailCtr"];
    
    for (NSInteger index = 0;index < hiddenNavCtrs.count;index++) {
        Class class = NSClassFromString([hiddenNavCtrs objectAtIndex:index]);
        if (class) {
            if ([viewController isKindOfClass:class]) {
                [viewController.navigationController setNavigationBarHidden:YES];
            }
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;

    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[APPUtils getThemeColor],NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_1]}];

    self.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
