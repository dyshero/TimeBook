//
//  AFNet.h
//
//  Created by SKY
//  Copyright © 翊sky. All rights reserved.
//

#import "AFHTTPSessionManager.h"
typedef NS_ENUM(NSInteger , HttpRequestType) {
    HttpRequestTypeGet = 0,
    HttpRequestTypePost,
};

typedef void(^SuccessBlock)(id object);//成功回传数据
typedef void(^FailureBlock)(NSError *error);//失败回传数据

@interface AFNet : NSObject

+ (void)requestWithUrl:(NSString *)url requestType:(HttpRequestType)requestType parameter:(NSDictionary *)parameter completation:(SuccessBlock)success failure:(FailureBlock)failure;
@end
