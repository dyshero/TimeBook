//
//  AdHubSplashDelegate.h
//  AdHubSDK
//
//  Created by Toymi on 16/12/3.
//  Copyright © 2016年 haobo. All rights reserved.
//

#import "AdHubAdDelegate.h"

@class AdHubSplash;
@class AdHubRequestError;

@protocol AdHubSplashDelegate <AdHubAdDelegate>

@required
/**
 @return 展现开屏点击二跳所需的 UIViewController，不能为空
 */
- (UIViewController *)adSplashViewControllerForPresentingModalView;

@optional

/**
 开屏请求成功
 */
- (void)splashDidReceiveAd:(AdHubSplash *)ad;

/**
 开屏请求失败
 */
- (void)splash:(AdHubSplash *)ad didFailToLoadAdWithError:(AdHubRequestError *)error;

/**
 开屏展现
 */
- (void)splashDidPresentScreen:(AdHubSplash *)ad;

/**
 开屏点击 landingPageURL 为空时说明有详情页
 */
- (void)splashDidClick:(NSString *)landingPageURL;

/**
 开屏消失
 */
- (void)splashDidDismissScreen:(AdHubSplash *)ad;

@end
