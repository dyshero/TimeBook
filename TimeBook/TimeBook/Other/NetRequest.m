//
//  User.m
//  CarMayor
//
//  Created by zjcheshi.com on 16/3/12.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "NetRequest.h"
#import "APIConfig.h"
#import "AFNet.h"

#import "NSDate+Category.h"

@implementation NetRequest

+ (void)loadRecommendWithPage:(int)page successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock {
    
    NSString *url = [NSString stringWithFormat:commend_api,[NSDate dateFromDay:page]];

    [AFNet getRequestHttpURL:url completation:^(id object) {
        
        if (successBlock) {
            successBlock(object);
        }
        
    } failure:^(NSError *error) {
        
        if (failBlock) {
            failBlock(@"");
        }
        
    }];
    
}

+ (void)loadWallpapersSuccessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock {
        
    [AFNet getRequestHttpURL:wallpaper_api completation:^(id object) {
        
        if (successBlock) {
            successBlock(object);
        }
        
    } failure:^(NSError *error) {
        
        if (failBlock) {
            failBlock(@"");
        }
        
    }];
}

+ (void)loadSampleReelsSuccessBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock {
    
    [AFNet getRequestHttpURL:sample_reels_api completation:^(id object) {
        
        if (successBlock) {
            successBlock(object);
        }
        
    } failure:^(NSError *error) {
        
        if (failBlock) {
            failBlock(@"");
        }
        
    }];
}

@end
