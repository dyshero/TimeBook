//
//  GoogleMobileAdsDefines.h
//  Google Mobile Ads SDK
//
//  Copyright (c) 2015 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_feature(nullability)  // Available starting in Xcode 6.3.
#define ADHub_NULLABLE_TYPE __nullable
#define ADHub_NONNULL_TYPE __nonnull
#define ADHub_NULLABLE nullable
#define ADHub_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#define ADHub_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#else
#define ADHub_NULLABLE_TYPE
#define ADHub_NONNULL_TYPE
#define ADHub_NULLABLE
#define ADHub_ASSUME_NONNULL_BEGIN
#define ADHub_ASSUME_NONNULL_END
#endif  // __has_feature(nullability)

#ifndef DEMO
#define DEMO
#endif


#ifndef AdHubLog

#ifdef DEBUG
#define AdHubLog(...) NSLog(__VA_ARGS__)
#else
#define AdHubLog(...)
#endif

#endif
