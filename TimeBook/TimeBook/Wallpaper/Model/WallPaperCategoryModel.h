//
//  WallPaperCategoryModel.h
//  TimeBook
//
//  Created by duodian on 2018/5/11.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WallPaperCategoryModel : NSObject
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *alias;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,strong) NSArray *thumbs;
@end
