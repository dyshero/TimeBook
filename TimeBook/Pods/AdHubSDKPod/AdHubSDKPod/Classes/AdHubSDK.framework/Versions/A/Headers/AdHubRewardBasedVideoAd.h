//
//  AdHubRewardBasedVideoAd.h
//  AdHubSDK
//
//  Created by wujian on 2/12/2016.
//  Copyright © 2016 haobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AdHubRewardBasedVideoAdDelegate.h"

@class AdHubAdRequest;

ADHub_ASSUME_NONNULL_BEGIN

/**
 激励视频广告
 */
@interface AdHubRewardBasedVideoAd : NSObject

/**
 用来接收激励视频广告读取和展示状态变化通知的 delegate
 */
@property(nonatomic, weak) id<AdHubRewardBasedVideoAdDelegate> delegate;

/**
 激励视频是否加载完毕
 */
@property(nonatomic, readonly, getter=isReady) BOOL ready;

/**
 激励视频广告单例对象
 */
+ (AdHubRewardBasedVideoAd *)sharedInstance;

/**
 加载激励视频广告

 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 */
- (void)loadAdWithSpaceID:(NSString *)spaceID
               spaceParam:(NSString *)spaceParam;

/**
 展示激励视频广告
 
 @param rootViewController 用于展示激励视频的 viewController。展示结束后，delegate 的 rewardBasedVideoAdDidClose: 方法将会被调用
 */
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end

ADHub_ASSUME_NONNULL_END
