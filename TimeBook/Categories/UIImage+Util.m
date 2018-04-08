//
//  UIImage+Util.m
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/7.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

+ (UIImage *)imageWithResource:(NSString *)name{
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [resourcePath stringByAppendingPathComponent:name];
    
    return [UIImage imageWithContentsOfFile:path];
    
}

@end
