//
//  AdHubInterstitial.h
//  AdHubSDK
//
//  Created by Toymi on 16/12/2.
//  Copyright © 2016年 haobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdHubInterstitialDelegate.h"

ADHub_ASSUME_NONNULL_BEGIN

/**
 插屏广告
 */
@interface AdHubInterstitial : NSObject

@property(nonatomic,readonly,copy)NSString *spaceID;
@property(nonatomic,readonly,copy)NSString *spaceParam;

/**
 用来接收插屏广告读取和展示状态变化通知的 delegate
 */
@property(nonatomic,weak)id<AdHubInterstitialDelegate> delegate;

/**
 初始化方法

 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @return 插屏广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam NS_DESIGNATED_INITIALIZER;

/**
 插屏加载
 */
- (void)loadAd;

/**
 返回 YES 表示插屏广告已经准备好可以展示。
 当这个值从 NO 变成 YES 后，delegate 的 interstitialAdDidReceiveAd: 方法将会被调用。
 */
@property(nonatomic,readonly,assign)BOOL isReady;

/**
 返回 YES 表示本次请求的广告已被展示过。
 每个插屏广告实例只能展示一次，展示过以后无论 load request 或者 present 都不会生效
 */
@property(nonatomic,readonly,assign)BOOL hasBeenUsed;

/**
 presentViewController:animated:
 默认 YES
 */
@property(nonatomic,assign)BOOL needAnimation;

/**
 视频广告是否播放完毕, 常用于在用户看完视频后发送奖励
 */
@property (nonatomic,readonly,assign)BOOL videoPlayFinishState;

/**
 展示插屏
 @param rootViewController 用于展示插屏的 viewController。展示结束后，delegate 的 interstitialDidDismissScreen: 方法将会被调用
 */
- (void)presentFromRootViewController:(UIViewController *)rootViewController;

/**
 * 插屏广告移除 开发者自行调用
 * 常用于点击广告之后
 */
- (void)interstitialCloseAd;

@end

ADHub_ASSUME_NONNULL_END
