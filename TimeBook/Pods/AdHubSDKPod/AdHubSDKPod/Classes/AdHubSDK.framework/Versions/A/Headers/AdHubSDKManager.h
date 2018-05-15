//
//  AdHubSDKManager.h
//  AdHubSDK
//
//  Created by Toymi on 11/30/16.
//  Copyright © 2016 haobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdHubSDKDefines.h"

ADHub_ASSUME_NONNULL_BEGIN

// SDK 管理主类
@interface AdHubSDKManager : NSObject

/**
 配置 AppID
 @param applicationID AppID
 */
+ (void)configureWithApplicationID:(NSString *)applicationID;


/**
 配置调试信息输出 Block （仅供开发联调使用）
 @param debugBlock 用于输出调试信息的 Block
 */
+ (void)configureDebugBlock:(void(^)(NSString *key, id info))debugBlock;

/**
 记录自定义事件
 @param eventID 自定义事件 ID
 */
+ (void)logEvent:(NSString *)eventID;



@end

ADHub_ASSUME_NONNULL_END
