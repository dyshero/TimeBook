//
//  WallPaperCategoryModel.m
//  TimeBook
//
//  Created by duodian on 2018/5/11.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "WallPaperCategoryModel.h"

@implementation WallPaperCategoryModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}
@end
