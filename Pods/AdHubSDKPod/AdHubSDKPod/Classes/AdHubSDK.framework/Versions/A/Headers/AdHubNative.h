//
//  AdHubNative.h
//  AdHubSDK
//
//  Created by koala on 3/2/17.
//  Copyright © 2017 haobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdHubNativeDelegate.h"
#import "AdHubNativeAdDataModel.h"
#import <UIKit/UIKit.h>

/**
 原生广告 : IMPORTANT 曝光时遵循看见广告在展示曝光
 */
@interface AdHubNative : NSObject

@property(nonatomic,readonly,copy)NSString *spaceID;
@property(nonatomic,readonly,copy)NSString *spaceParam;

/**
 是否由SDK打开地址 默认NO
 */
@property (nonatomic,assign)BOOL sdkOpenAdClickUrl;

/**
 用来接收原生广告读取和展示状态变化通知的 delegate
 */
@property (nonatomic,weak)id<AdHubNativeDelegate>delegate;

/**
 广告加载成功后获得的 原生广告数据模型
 */
@property (nonatomic,strong,readonly)NSArray<AdHubNativeAdDataModel *>*adDataModels;

/**
 初始化方法
 
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @return 原生广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam NS_DESIGNATED_INITIALIZER;

/**
 原生广告加载
 */
- (void)loadAd;

/**
 调用者通知 SDK 曝光展示了某个广告
 @param adDataModel 被展示的广告 Model
 */
- (void)didShowAdDataModel:(AdHubNativeAdDataModel *)adDataModel;

/**
 调用者通知 SDK 点击了某个广告
 @param adDataModel 被点击的广告 Model
 */
- (void)didClickAdDataModel:(AdHubNativeAdDataModel *)adDataModel;

@end
