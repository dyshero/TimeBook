//
//  AdHubCustomView.h
//  AdHubSDK
//
//  Created by koala on 2017/3/1.
//  Copyright © 2017年 haobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdHubCustomViewDelegate.h"

/**
 自定义广告
 */
@interface AdHubCustomView : UIView

@property(nonatomic, readonly, copy) NSString *spaceID;
@property(nonatomic, readonly, copy) NSString *spaceParam;

/**
 用来接收自定义广告读取和展示状态变化通知的 delegate
 */
@property(nonatomic, weak) id<AdHubCustomViewDelegate> delegate;

/**
 视频广告是否播放完毕, 常用于在用户看完视频后发送奖励
 */
@property (nonatomic,readonly,assign)BOOL videoPlayFinishState;

/**
 初始化方法
 
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @return 自定义广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam;

/**
 自定义广告加载
 */
- (void)loadAd;

/**
 * 自定义广告移除 开发者自行调用
 * 常用于点击广告之后
 */
- (void)customCloseAd;

@end


