//
//  AdHubRequestError.h
//  AdHubSDK
//
//  Created by Toymi on 16/12/2.
//  Copyright © 2016年 haobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdHubSDKDefines.h"

/// AdHubSDK Ads error domain.
extern NSString *const kAdHubErrorDomain;

/// NSError codes for AdHub error domain.
typedef NS_ENUM(NSInteger, AdHubErrorCode) {
    /// 无效的请求
    kAdHubErrorInvalidRequest,
    
    /// 广告请求成功，但没有返回广告内容
    kAdHubErrorNoFill,
    
    /// 在请求广告数据过程中出现了网络错误
    kAdHubErrorNetworkError,
    
    /// 广告服务器返回了错误信息
    kAdHubErrorServerError,
    
    /// 内部错误
    kAdHubErrorInternalError,
    
    /// 无效的参数
    kAdHubErrorInvalidArgument,
    
    /// 广告请求能够接收到响应，但返回数据格式错误
    kAdHubErrorReceivedInvalidResponse,
    
    /// 当前设备系统版本太低
    kAdHubErrorOSVersionTooLow,
    
    /// 请求超时
    kAdHubErrorTimeout,
    
    /// 插屏广告实例已被使用过，不再发送多次请求
    kAdHubErrorInterstitialAlreadyUsed,
    
    /// 第三方合作广告数据错误
    kAdHubErrorMediationInvalidParameter = 1001,
    
    /// 第三方合作广告数据错误
    kAdHubErrorMediationDataError,
    
    /// 第三方合作广告适配错误
    kAdHubErrorMediationAdapterError,
    
    /// 第三方合作广告请求成功，但是没有返回任何广告内容
    kAdHubErrorMediationNoFill,
    
    /// 第三方合作广告请求已停止
    kAdHubErrorMediationStopped,
    
    /// 无效的第三方广告尺寸
    kAdHubErrorMediationInvalidAdSize
};

typedef NS_ENUM(NSInteger, AdHubAdClickMessageType) {
    /// landingPageUrl不存在
    kAdHubAdClickMessageTypeInvalidLandingPageUrl,
    
    /// 展现二级页面vc不存在
    kAdHubAdClickMessageTypeInvalidPresentVC,
    
    /// 正常
    kAdHubAdClickMessageTypeNormal,
    
    /// deeplink
    kAdHubAdClickOpenDeeplink,
};

@interface AdHubRequestError : NSError

+ (AdHubRequestError *)errorWithCode:(AdHubErrorCode)code;

@end
