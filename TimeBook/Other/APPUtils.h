//
//  APPUtils.h
//  TimeBook
//
//  Created by CarMayor on 2017/12/11.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPUtils : NSObject

+ (void)saveObject:(id)object forKey:(NSString *)key;

+ (id)getObjectForKey:(NSString *)key;

+ (UIColor *)getThemeColor;
+ (UIColor *)getThemeLightColor;

+ (void)setColorAtIndex:(int)index;

@end
