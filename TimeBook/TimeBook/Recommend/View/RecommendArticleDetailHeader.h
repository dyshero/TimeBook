//
//  RecommendArticleDetailHeader.h
//  TimeBook
//
//  Created by CarMayor on 2017/12/8.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface RecommendArticleDetailHeader : UIView

@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (nonatomic,strong) RecommendModel *model;

@end
