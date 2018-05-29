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
#import <SVProgressHUD.h>
#import "JPUSHService.h"
#import "JANALYTICSService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<AdHubSplashDelegate,JPUSHRegisterDelegate>
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
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self configSplash];
//    });
    
    [self registerPushWithOptions:launchOptions];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:0.5];
    
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = @"7607b35c8ca5a5ca3a0ebf45";
    [JANALYTICSService setupWithConfig:config];
    
    return YES;
}

- (void)registerPushWithOptions:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"7607b35c8ca5a5ca3a0ebf45"
                          channel:@"today"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        } else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
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

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知");
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


@end
