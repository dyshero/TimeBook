//
//  AdHubSplash.h
//  AdHubSDK
//
//  Created by Toymi on 16/12/3.
//  Copyright © 2016年 haobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdHubSplashDelegate.h"

/**
 开屏广告
 */
@interface AdHubSplash : NSObject

@property(nonatomic,readonly,copy)NSString *spaceID;
@property(nonatomic,readonly,copy)NSString *spaceParam;

/**
 用来接收开屏广告读取和展示状态变化通知的 delegate
 */
@property(nonatomic,weak)id<AdHubSplashDelegate>delegate;

/**
 开屏广告是否加载完毕
 */
@property(nonatomic,readonly,assign)BOOL isReady;

/**
 视频广告是否播放完毕, 常用于在用户看完视频后发送奖励
 */
@property (nonatomic,readonly,assign)BOOL videoPlayFinishState;

/**
 初始化方法
 
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @return 开屏广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam NS_DESIGNATED_INITIALIZER;

/**
 请求加载开屏广告并在 UIWindow 中展现
 */
- (void)loadAndDisplayUsingKeyWindow:(UIWindow *)window;

/**
 请求加载开屏广告并在 UIView 中展现
 */
- (void)loadAndDisplayUsingContainerView:(UIView *)view;

/**
 * 开屏广告移除 开发者自行调用
 * 常用于点击广告之后没有详情页的情况
 */
- (void)splashCloseAd;

@end
