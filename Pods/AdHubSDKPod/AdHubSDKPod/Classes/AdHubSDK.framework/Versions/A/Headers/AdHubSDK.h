//
//  AdHubSDK.h
//  AdHubSDK
//
//  Created by Toymi on 16/11/20.
//  Copyright © 2016年 haobo. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for AdHubSDK.
FOUNDATION_EXPORT double AdHubSDKVersionNumber;

//! Project version string for AdHubSDK.
FOUNDATION_EXPORT const unsigned char AdHubSDKVersionString[];

#import <AdHubSDK/AdHubSDKManager.h>
#import <AdHubSDK/AdHubSDKDefines.h>
#import <AdHubSDK/AdHubRequestError.h>
#import <AdHubSDK/AdHubAdDelegate.h>

// 插屏广告
#import <AdHubSDK/AdHubInterstitial.h>
#import <AdHubSDK/AdHubInterstitialDelegate.h>

// Banner 广告
#import <AdHubSDK/AdHubBannerView.h>
#import <AdHubSDK/AdHubBannerViewDelegate.h>

// 自定义广告
#import <AdHubSDK/AdHubCustomView.h>
#import <AdHubSDK/AdHubCustomViewDelegate.h>

// 开屏广告
#import <AdHubSDK/AdHubSplash.h>
#import <AdHubSDK/AdHubSplashDelegate.h>

// 激励视频广告
#import <AdHubSDK/AdHubRewardBasedVideoAd.h>
#import <AdHubSDK/AdHubRewardBasedVideoAdDelegate.h>

// 原生广告
#import <AdHubSDK/AdHubNative.h>
#import <AdHubSDK/AdHubNativeDelegate.h>
#import <AdhubSDK/AdHubNativeAdDataModel.h>


