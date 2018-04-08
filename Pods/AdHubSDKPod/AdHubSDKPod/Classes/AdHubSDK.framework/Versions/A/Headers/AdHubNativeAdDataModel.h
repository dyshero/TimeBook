//
//  AdHubNativeAdDataModel.h
//  AdHubSDK
//
//  Created by toymi on 3/17/17.
//  Copyright © 2017 haobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdHubAdContent;

typedef NS_ENUM(NSUInteger){
    AdHubNativeAdDataModelForAppInstall    = 0,
    AdHubNativeAdDataModelForContent       = 1
} AdHubNativeAdDataModelType;

@interface AdHubNativeAdDataModel : NSObject

// 原生广告类型
@property (nonatomic)AdHubNativeAdDataModelType type;

// 原生广告基础信息
@property (nonatomic,readonly,strong)NSString *headLine;
@property (nonatomic,readonly,strong)NSString *imageUrlString; // Deprecate use `images` replace
@property (nonatomic,readonly,strong)NSString *body; // Deprecate use `texts` replace
@property (nonatomic,readonly,strong)NSString *action;
@property (nonatomic,readonly,strong)NSString *landingUrl;  // landing page url
@property (nonatomic,readonly,strong)NSString *deeplinkUrl; // deeplink
@property (nonatomic,readonly,strong)NSString *phoneNumber; // phoneNumber
@property (nonatomic,readonly,strong)NSArray *images; // @[imageUrlString, ...]
@property (nonatomic,readonly,strong)NSArray *videos; // @[videoUrlString, ...]
@property (nonatomic,readonly,strong)NSArray *texts;  // @[body, ...]

// 原生内容广告信息，type 为 AdHubNativeAdDataModelForContent 时有效
@property (nonatomic,readonly,strong)NSString *logoUrlString;
@property (nonatomic,readonly,strong)NSString *advertiser;

// 原生 App 推荐广告信息，type 为 AdHubNativeAdDataModelForAppInstall 时有效
@property (nonatomic,readonly,strong)NSString *appIconUrlString;
@property (nonatomic,readonly,strong)NSString *star;
@property (nonatomic,readonly,strong)NSString *store;
@property (nonatomic,readonly,strong)NSString *price;

// 原生数据 json 字符串 开发者可以自行解析展示
@property (nonatomic,readonly,strong)NSString *jsonString;

// adLogo 信息
/** 当 adLabelUrl 不为空时展示此url图片，否则展示adLable内容 */
@property (nonatomic,readonly,strong)NSString *adLabelURL;
/** 广告字样，如：“广告”, 目前固定为“广告” */
@property (nonatomic,readonly,strong)NSString *adLabel;

/** 当 sourceUrl 不为空时展示此url图片，否则展示sourceLable内容 */
@property (nonatomic,readonly,strong)NSString *sourceURL;
/** 广告来源的文字 如：“ADHUB广告”，如有特殊需求，可以展示此文字 */
@property (nonatomic,readonly,strong)NSString *sourceLabel;

// SDK 内部方法
+ (AdHubNativeAdDataModel *)modelFromAdContent:(AdHubAdContent *)adContent;

@end
