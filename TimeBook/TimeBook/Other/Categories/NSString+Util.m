//
//  NSString+Util.m
//
//  Created by SKY
//  Copyright © 翊sky. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

-(NSString *)day{
    NSArray *timeArray = [self componentsSeparatedByString:@"-"];
    return timeArray[2];
}

-(NSString *)month_true{
    NSArray *timeArray = [self componentsSeparatedByString:@"-"];
    return timeArray[1];
}

-(NSString *)month{
    
    NSArray *timeArray = [self componentsSeparatedByString:@"-"];
    NSArray *dateArray = @[@"Jan",@"Feb",@"Mar",
                           @"Apr",@"May",@"June",
                           @"July",@"Aug",@"Sept",
                           @"Oct",@"Nov",@"Dec"];
    
    return dateArray[[NSString stringWithFormat:@"%@",timeArray[1]].intValue-1];
}

-(NSString *)year{
    NSArray *timeArray = [self componentsSeparatedByString:@"-"];
    return timeArray[0];
}

@end
