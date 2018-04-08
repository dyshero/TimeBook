//
//  APPUtils.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/11.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "APPUtils.h"

@implementation APPUtils

+ (void)saveObject:(id)object forKey:(NSString *)key {
    
    //使用NSUserDefaults 存储数据
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getObjectForKey:(NSString *)key {
    //取出NSUserDefaults数据
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (UIColor *)getThemeColor {
    
    NSString *indexStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme_color"];
    if (indexStr == nil || [indexStr isKindOfClass:[NSNull class]]) {
        indexStr = @"0";
    }
    
    NSArray *colors = @[COLOR_1, COLOR_2, COLOR_3, COLOR_4, COLOR_5, COLOR_6];
    int index = [indexStr intValue];
    
    return colors[index];
}

+ (UIColor *)getThemeLightColor {

    NSString *indexStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"theme_color"];
    if (indexStr == nil || [indexStr isKindOfClass:[NSNull class]]) {
        indexStr = @"0";
    }
    
    NSArray *colors = @[COLOR_1_LIGHT, COLOR_2_LIGHT, COLOR_3_LIGHT, COLOR_4_LIGHT, COLOR_5_LIGHT, COLOR_6_LIGHT];
    int index = [indexStr intValue];
    
    return colors[index];
}

+ (void)setColorAtIndex:(int)index {
    NSString *indexStr = [NSString stringWithFormat:@"%d",index];
    [[NSUserDefaults standardUserDefaults] setObject:indexStr forKey:@"theme_color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change_theme_color" object:nil];
}

@end
