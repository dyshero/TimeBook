//
//  User.h
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/12.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id object);
typedef void(^FailBlock)(NSString *error);

@interface NetRequest : NSObject

+ (void)loadRecommendWithPage:(int)page successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

+ (void)loadWallpapersSuccessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

+ (void)loadSampleReelsSuccessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

@end
