//
//  AdHubCustomViewDelegate.h
//  AdHubSDK
//
//  Created by koala on 2017/3/1.
//  Copyright © 2017年 haobo. All rights reserved.
//

#import "AdHubAdDelegate.h"

@class AdHubCustomView;
@class AdHubRequestError;

@protocol AdHubCustomViewDelegate <AdHubAdDelegate>

@required
/**
 @return 展现自定义广告点击二跳所需的 UIViewController，不能为空
 */
- (UIViewController *)adCustomViewControllerForPresentingModalView;

@optional

/**
 自定义广告加载成功
 */
- (void)adCustomViewDidReceiveAd:(AdHubCustomView *)customView;

/**
 自定义广告加载失败
 */
- (void)adCustomView:(AdHubCustomView *)customView didFailToReceiveAdWithError:(AdHubRequestError *)error;

/**
 自定义广告关闭
 */
- (void)adCustomViewDidDismissScreen:(AdHubCustomView *)customView;

/**
 自定义广告点击 landingPageURL 为空时说明有详情页
 */
- (void)customDidClick:(NSString *)landingPageURL;

@end
