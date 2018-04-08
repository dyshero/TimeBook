//
//  RecommendModel.h
//  TimeBook
//
//  Created by CarMayor on 2017/12/7.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject

@property (nonatomic,assign) int type;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,copy) NSString *destination;
@property (nonatomic,copy) NSString *android_wallpaper_url;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ios_wallpaper_url;
@property (nonatomic,copy) NSString *publish_date;
@property (nonatomic,copy) NSArray *articles;

@property (nonatomic,copy) NSString *destination_intro;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *name_en;
@property (nonatomic,copy) NSString *name_zh_cn;
@property (nonatomic,copy) NSString *photo_author;
@property (nonatomic,copy) NSDictionary *trip;
@property (nonatomic,copy) NSDictionary *attraction;
@property (nonatomic,copy) NSString *image_url;
@property (nonatomic,copy) NSString *destination_intro_title;
@property (nonatomic,copy) NSString *text_author;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSArray *description_notes;
@property (nonatomic,copy) NSArray *photos;
@property (nonatomic,copy) NSArray *articleModels;

@end
