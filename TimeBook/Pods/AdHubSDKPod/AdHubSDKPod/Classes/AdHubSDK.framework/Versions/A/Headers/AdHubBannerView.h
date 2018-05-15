//
//  AdHubBannerView.h
//  AdHubSDK
//
//  Created by Toymi on 16/12/13.
//  Copyright © 2016年 haobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdHubBannerViewDelegate.h"

/**
 Banner 广告
 */
@interface AdHubBannerView : UIView

@property(nonatomic,readonly,copy)NSString *spaceID;
@property(nonatomic,readonly,copy)NSString *spaceParam;

/**
 用来接收 Banner 广告读取和展示状态变化通知的 delegate
 */
@property(nonatomic,weak)id<AdHubBannerViewDelegate>delegate;

/**
 视频广告是否播放完毕, 常用于在用户看完视频后发送奖励
 */
@property (nonatomic,readonly,assign)BOOL videoPlayFinishState;

/**
 初始化方法
 
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @return Banner 广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID spaceParam:(NSString *)spaceParam;

/**
 Banner 加载
 */
- (void)loadAd;

/**
 * Banner 广告移除 开发者自行调用
 * 常用于点击广告之后
 */
- (void)bannerCloseAd;

@end
