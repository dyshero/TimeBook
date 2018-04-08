//
//  BaseViewController.h
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/1.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *datas;

- (void)back;

- (void)reloadThemeColor;

@end
