//
//  AdHubNativeDelegate.h
//  AdHubSDK
//
//  Created by koala on 3/3/17.
//  Copyright © 2017 haobo. All rights reserved.
//

#import "AdHubAdDelegate.h"
#import <UIKit/UIKit.h>

@class AdHubNative;
@class AdHubRequestError;

@protocol AdHubNativeDelegate <AdHubAdDelegate>

@required
/**
 @return 展现 Native 点击所需的 UIViewController，不能为空
 */
- (UIViewController *)adNativeViewControllerForPresentingAdDetail;

/**
 @return 展现 Native 所在 UIView，不能为空
 */
- (UIView *)adNativeShowView;

@optional
/**
 原生加载成功
 */
- (void)nativeDidLoaded:(AdHubNative *)ad;

/**
 原生加载失败
 */
- (void)native:(AdHubNative *)ad didFailToLoadAdWithError:(AdHubRequestError *)error;

/**
 自定义广告点击 tipMessage 为空时说明有详情页
 */
- (void)nativeDidClick:(NSString *)tipMessage;

@end
