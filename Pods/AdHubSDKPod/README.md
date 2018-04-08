# AdHubSDKPod

[![CI Status](http://img.shields.io/travis/songMW/AdHubSDKPod.svg?style=flat)](https://travis-ci.org/songMW/AdHubSDKPod)
[![Version](https://img.shields.io/cocoapods/v/AdHubSDKPod.svg?style=flat)](http://cocoapods.org/pods/AdHubSDKPod)
[![License](https://img.shields.io/cocoapods/l/AdHubSDKPod.svg?style=flat)](http://cocoapods.org/pods/AdHubSDKPod)
[![Platform](https://img.shields.io/cocoapods/p/AdHubSDKPod.svg?style=flat)](http://cocoapods.org/pods/AdHubSDKPod)

## Installation
AdHubSDKPod supports multiple methods for installing the library in a project.

## Installation with CocoaPods
CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AdHubSDKPod in your projects.

## Podfile
```ruby
platform :ios, '7.0'

target 'TargetName' do
pod "AdHubSDKPod", '~> 1.9'

end
```

Then, run the following command:

```bash
$ pod install
```

## Usage
### Create a BannerView Ad
```objc
- (void)showBanner:(NSString *)spaceID
{
    [self showHUD];
    self.banner = [[AdHubBannerView alloc] initWithSpaceID:spaceID spaceParam:[HaoBoSpaceInfo sharedInstall].spacefParam];
    self.banner.delegate = self;
    [self.banner loadAd];
}

- (UIViewController *)adBannerViewControllerForPresentingModalView
{
    return self;
}

- (void)adViewDidReceiveAd:(AdHubBannerView *)bannerView
{
    [self cleanHUD];
    [self adContentShowInBgView];
    [self.showAdBgView addSubview:bannerView];
    [bannerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.showAdBgView);
        make.width.equalTo(@(bannerView.frame.size.width));
        make.height.equalTo(@(bannerView.frame.size.height));
    }];
}

- (void)adViewDidDismissScreen:(AdHubBannerView *)bannerView
{

}

- (void)adView:(AdHubBannerView *)bannerView didFailToReceiveAdWithError:(AdHubRequestError *)error
{
    self.banner = nil;
    [self.showAdBgView removeFromSuperview];
    [self cleanHUD];
}

- (void)adViewClicked:(NSString *)landingPageURL
{
    [self printLandingPageUrlTipMessage:landingPageURL];
    if (!landingPageURL.length) {
        [self showAdBgViewCloseBtnClick];
    }
}

```
### Create a Interstitial Ad
```objc
- (void)showInterstitial:(NSString *)spaceID
{
    [self showHUD];
    self.interstitial = [[AdHubInterstitial alloc] initWithSpaceID:spaceID spaceParam:[HaoBoSpaceInfo sharedInstall].spacefParam];
    self.interstitial.delegate = self;
    self.interstitial.needAnimation = NO;
    [self.interstitial loadAd];
}

- (void)interstitialDidReceiveAd:(AdHubInterstitial *)ad
{
    [self cleanHUD];
    [self.interstitial presentFromRootViewController:self];
}

- (void)interstitialDidFailToPresentScreen:(AdHubInterstitial *)ad
{
    [self cleanHUD];
}

- (void)interstitial:(AdHubInterstitial *)ad didFailToReceiveAdWithError:(AdHubRequestError *)error
{
    [self cleanHUD];
}

- (void)interstitialDidClick:(NSString *)landingPageURL
{
    [self printLandingPageUrlTipMessage:landingPageURL];
}
```

### Create a Splash Ad
```objc
- (void)showSplash:(NSString *)spaceID
{
    [self showHUD];
    self.customSplashView = [[UIView alloc]init];
    [[UIApplication sharedApplication].keyWindow addSubview:self.customSplashView];
    [self.customSplashView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.customSplashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo([UIApplication sharedApplication].keyWindow);
    }];

    UIImageView *splashContainer = [[UIImageView alloc]initWithImage:[HaoBoUtls launchImage]];
    [splashContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.customSplashView addSubview:splashContainer];
    [splashContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    _splash = [[AdHubSplash alloc] initWithSpaceID:spaceID spaceParam:[HaoBoSpaceInfo sharedInstall].spacefParam];
    _splash.delegate = self;
    [_splash loadAndDisplayUsingContainerView:self.customSplashView];
}

- (UIViewController *)adSplashViewControllerForPresentingModalView
{
    return self;
}

- (void)splashDidReceiveAd:(AdHubSplash *)ad
{
    [self cleanHUD];
}

- (void)splash:(AdHubSplash *)ad didFailToLoadAdWithError:(AdHubRequestError *)error
{
    [self splashClean];
}

- (void)splashDidDismissScreen:(AdHubSplash *)ad
{
    [self splashClean];
}

- (void)splashDidClick:(NSString *)landingPageURL
{
    [self printLandingPageUrlTipMessage:landingPageURL];
    [_splash splashCloseAd];
}

- (void)splashDidPresentScreen:(AdHubSplash *)ad
{

}

- (void)splashClean
{
    [self cleanHUD];
    self.splash.delegate = nil;
    self.splash = nil;
    [self.customSplashView removeFromSuperview];
    self.customSplashView = nil;
}
```

### Create a Custom Ad
```objc
- (UIViewController *)adCustomViewControllerForPresentingModalView
{
    return self;
}

- (void)adCustomViewDidReceiveAd:(AdHubCustomView *)customView
{
    [self cleanHUD];
    [self adContentShowInBgView];
    [self.showAdBgView addSubview:customView];
    [customView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.showAdBgView);
        make.width.equalTo(@(customView.frame.size.width));
        make.height.equalTo(@(customView.frame.size.height));
    }];
}

- (void)adCustomViewDidDismissScreen:(AdHubCustomView *)customView
{
    _custom = nil;
}

- (void)adCustomView:(AdHubCustomView *)customView didFailToReceiveAdWithError:(AdHubRequestError *)error
{
    _custom = nil;
    [self cleanHUD];
}

- (void)showCustom:(NSString *)spaceID
{
    [self showHUD];
    self.custom = [[AdHubCustomView alloc] initWithSpaceID:spaceID spaceParam:[HaoBoSpaceInfo sharedInstall].spacefParam];
    self.custom.frame = CGRectZero;
    self.custom.delegate = self;
    [self.custom loadAd];
}

- (void)customDidClick:(NSString *)landingPageURL
{
    [self printLandingPageUrlTipMessage:landingPageURL];
}
```

### Create a RewardVideo Ad
```objc
- (void)showRewardVideo:(NSString *)spaceID
{
    [self showHUD];
    [AdHubRewardBasedVideoAd sharedInstance].delegate = self;
    [[AdHubRewardBasedVideoAd sharedInstance] loadAdWithSpaceID:spaceID spaceParam:[HaoBoSpaceInfo sharedInstall].spacefParam];
}

- (UIViewController *)adRewardViewControllerForPresentingModalView
{
    return self;
}

- (void)rewardBasedVideoAdDidReceiveAd:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd
{
    [self cleanHUD];
    [[AdHubRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
}

- (void)rewardBasedVideoAd:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(NSObject *)reward
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"得到奖励" message:(NSString *)reward preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

    }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)rewardBasedVideoAd:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(AdHubRequestError *)error
{
    [self cleanHUD];
}
```

### Create a Native Ad
```objc
- (void)showNative:(NSString *)spaceID
{
    [self showHUD];
    self.native = [[AdHubNative alloc] initWithSpaceID:spaceID spaceParam:[HaoBoSpaceInfo sharedInstall].spacefParam];
    self.native.delegate = self;
    self.native.sdkOpenAdClickUrl = YES;
    [self.native loadAd];
}

- (void)nativeDidLoaded:(AdHubNative *)ad
{
    [self cleanHUD];
    AdHubNativeAdDataModel *dataModel = ad.adDataModels[0];

    NSString *text = [self objcIsArray:dataModel.texts] ? [dataModel.texts componentsJoinedByString:@"---"] : @"";
    NSString *image = [self objcIsArray:dataModel.images] ? [dataModel.images componentsJoinedByString:@"---"] : @"";
    NSString *video = [self objcIsArray:dataModel.videos] ? [dataModel.videos componentsJoinedByString:@"---"] : @"";

    NSString *message = [NSString stringWithFormat:@"headLine:%@\nimage:%@\nbody:%@\naction:%@\ntexts:%@\nimages:%@\nvideos:%@\nlandingUrl:%@\nlogoUrlString:%@\nadvertiser:%@\nappIconUrlString:%@\nstar:%@\nstore:%@\nprice:%@", dataModel.headLine, dataModel.imageUrlString, dataModel.body, dataModel.action, text, image, video, dataModel.landingUrl, dataModel.logoUrlString, dataModel.advertiser, dataModel.appIconUrlString, dataModel.star, dataModel.store, dataModel.price];
    [self showAlertWithTitle:@"This is Native Ad" message:message withHandler:^{
        [self nativeClickExposeLog:dataModel];
    }];

    [self nativeShowExposeLog:dataModel];
}

- (void)nativeDidClick:(NSString *)tipMessage
{
    [self printLandingPageUrlTipMessage:tipMessage];
}

- (void)native:(AdHubNative *)ad didFailToLoadAdWithError:(AdHubRequestError *)error
{
    [self cleanHUD];
    self.native = nil;
}

- (UIView *)adNativeShowView
{
    return self.view;
}

- (UIViewController *)adNativeViewControllerForPresentingAdDetail
{
    return self;
}

- (void)nativeShowExposeLog:(AdHubNativeAdDataModel *)dataModel
{
    [self.native didShowAdDataModel:dataModel];
}

- (void)nativeClickExposeLog:(AdHubNativeAdDataModel *)dataModel
{
    [self.native didClickAdDataModel:dataModel];
}

- (void)setNativeAdSDKOpenUrl:(BOOL)state
{
    self.native.sdkOpenAdClickUrl = state;
}

- (void)printLandingPageUrlTipMessage:(NSString *)landingPageUrl
{
    if (landingPageUrl.length) {
        NSLog(@"----------------%@----------------", landingPageUrl);
    }
    else{
        NSLog(@"landingPageUrl is nil, open ad sucess!");
    }
}
```

## Declare
* spaceID：ad ID
* appID：appID
* spacefParam：@""
