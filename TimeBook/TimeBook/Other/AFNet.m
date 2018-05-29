//
//  AFNet.m
//
//  Created by SKY
//  Copyright © 翊sky. All rights reserved.
//

#import "AFNet.h"

@implementation AFNet

+ (id)shareManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName = YES;
        manager.securityPolicy  = securityPolicy;
        
        manager.requestSerializer.timeoutInterval = 12.f;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"text/javascript",nil];
    });
    return manager;
}

+ (void)requestWithUrl:(NSString *)url requestType:(HttpRequestType)requestType parameter:(NSDictionary *)parameter completation:(SuccessBlock)success failure:(FailureBlock)failure {
    [self checkNetworkReachabilityStatus];
    AFHTTPSessionManager *manager = [AFNet shareManager];
    [self setNetworkActivityIndicator:YES];
    if (requestType == HttpRequestTypeGet) {
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if (success) {
                success(responseData);
            }
            [self setNetworkActivityIndicator:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self setNetworkActivityIndicator:NO];
            if (failure) {
                failure(error);
            }
        }];
    } else {
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (responseData == nil) {
                return;
            }
            if (success && responseData) {
                success(responseData);
            }
            [self setNetworkActivityIndicator:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self setNetworkActivityIndicator:NO];
            if (failure) {
                failure(error);
            }
        }];
    }
}


//检查网络
+ (void)checkNetworkReachabilityStatus{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:{//手机网络
                NSLog(@"手机网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{//wifi
                NSLog(@"wifi");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable://没网
            case AFNetworkReachabilityStatusUnknown:{//未知
                NSLog(@"没网");
                return;
                break;
            }
            default:
                break;
        }
        
    }];
}

//网络活动指示
+ (void)setNetworkActivityIndicator:(BOOL)sign {
    UIApplication *app = [UIApplication sharedApplication];
    [app setNetworkActivityIndicatorVisible:sign];
}
@end
