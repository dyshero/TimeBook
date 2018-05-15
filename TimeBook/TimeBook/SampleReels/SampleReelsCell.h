//
//  SampleReelsCell.h
//  TimeBook
//
//  Created by CarMayor on 2017/12/11.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "RecommendModel.h"

@protocol SampleReelsCellProtocol <NSObject>

- (void)selectCellWithModel:(RecommendModel *)model;

@end

@interface SampleReelsCell : BaseTableViewCell

@property (nonatomic,strong) RecommendModel *model;

@property (nonatomic,weak) id <SampleReelsCellProtocol> delegate;

@end
