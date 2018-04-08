//
//  AdHubBannerViewDelegate.h
//  AdHubSDK
//
//  Created by Toymi on 16/12/17.
//  Copyright © 2016年 haobo. All rights reserved.
//

#import "AdHubAdDelegate.h"

@class AdHubBannerView;
@class AdHubRequestError;

@protocol AdHubBannerViewDelegate <AdHubAdDelegate>

@required
/**
 @return 展现 Banner 点击二跳所需的 UIViewController，不能为空
 */
- (UIViewController *)adBannerViewControllerForPresentingModalView;

@optional

// Banner 加载成功
- (void)adViewDidReceiveAd:(AdHubBannerView *)bannerView;

// Banner 加载失败
- (void)adView:(AdHubBannerView *)bannerView didFailToReceiveAdWithError:(AdHubRequestError *)error;

// Banner 即将展现
- (void)adViewWillPresentScreen:(AdHubBannerView *)bannerView;

// Banner 点击 landingPageURL 为空时说明有详情页
- (void)adViewClicked:(NSString *)landingPageURL;

// Banner 关闭
- (void)adViewDidDismissScreen:(AdHubBannerView *)bannerView;

@end
