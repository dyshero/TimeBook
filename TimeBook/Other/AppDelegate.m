//
//  AppDelegate.m
//  TimeBook
//
//  Created by CarMayor on 2017/12/6.
//  Copyright © 2017年 CarMayor. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "BaseNavigationController.h"
#import <AdHubSDK/AdHubSDK.h>
#import "LaunchView.h"

@interface AppDelegate ()<AdHubSplashDelegate>
@property (nonatomic,strong)AdHubSplash *splash;
@property (nonatomic,strong)UIView *splashContainerView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    HomeController *homeCtr = [HomeController classInitializtion];
    BaseNavigationController *rootCtr = [[BaseNavigationController alloc] initWithRootViewController:homeCtr];
    self.window.rootViewController = rootCtr;
    [self.window makeKeyAndVisible];
    [AdHubSDKManager configureWithApplicationID:@"1678"];
    [LaunchView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configSplash];
    });
    return YES;
}

- (void)configSplash {
    _splashContainerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _splash = [[AdHubSplash alloc] initWithSpaceID:@"4765" spaceParam:@""];
    [_splash loadAndDisplayUsingContainerView:_splashContainerView];
    _splash.delegate = self;
    [self.window addSubview:_splashContainerView];
}

- (void)splash:(AdHubSplash *)ad didFailToLoadAdWithError:(AdHubRequestError *)error {
    _splash = nil;
    [self.splashContainerView removeFromSuperview];
    self.splashContainerView = nil;
}

- (UIViewController *)adSplashViewControllerForPresentingModalView {
    return self.window.rootViewController;
}

- (void)splashDidClick:(NSString *)url {
    [_splash splashCloseAd];
}

- (void)splashDidDismissScreen:(AdHubSplash *)ad {
    _splash = nil;
    [self.splashContainerView removeFromSuperview];
    self.splashContainerView = nil;
}

@end
