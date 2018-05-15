#import "AdHubAdDelegate.h"

@class AdHubRewardBasedVideoAd;
@class AdHubRequestError;

@protocol AdHubRewardBasedVideoAdDelegate<AdHubAdDelegate>

@required
/**
 奖励发生了
 */
- (void)rewardBasedVideoAd:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd
    didRewardUserWithReward:(NSObject *)reward;

@optional

/**
 视频加载失败
 */
- (void)rewardBasedVideoAd:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(AdHubRequestError *)error;

/**
 视频加载完毕
 */
- (void)rewardBasedVideoAdDidReceiveAd:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd;

/**
 视频被打开
 */
- (void)rewardBasedVideoAdDidOpen:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd;

/**
 视频开始播放
 */
- (void)rewardBasedVideoAdDidStartPlaying:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd;

/**
 视频关闭
 */
- (void)rewardBasedVideoAdDidClose:(AdHubRewardBasedVideoAd *)rewardBasedVideoAd;


@end

