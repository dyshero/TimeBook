//
//  UIImageView+Util.h
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/2.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Util)

+ (UIImageView *)imageViewWithLocalImage:(NSString *)image frame:(CGRect)frame;

+ (UIImageView *)imageViewWithNetImage:(NSString *)imgURL frame:(CGRect)frame;

- (void)loadWithImgUrl:(NSString *)imgURL complete:(void (^)())complete;

- (void)loadProgressImageWithUrl:(NSString *)imgUrl complete:(void (^)())complete;
@end
