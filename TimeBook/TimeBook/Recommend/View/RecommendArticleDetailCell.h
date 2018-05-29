//
//  RecommendArticleDetailCell.h
//  TimeBook
//
//  Created by CarMayor on 2017/12/8.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "RecommendModel.h"

@protocol RecommendArticleDetailCellProtocol <NSObject>

- (void)selectCellWithModel:(RecommendModel *)model;

@end

@interface RecommendArticleDetailCell : BaseTableViewCell

@property (nonatomic,weak) id <RecommendArticleDetailCellProtocol> delegate;

@property (nonatomic,strong) RecommendModel *model;

@end
