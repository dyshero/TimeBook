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
typedef void(^RequestFailBlock)(NSString *msg);//请求失败
typedef void(^ProgressBlock)(NSProgress *progress);//上传或下载进度
typedef void(^FormDataBlock)(id<AFMultipartFormData> formData);

@interface AFNet : NSObject

#pragma mark - 更正接口后新的请求
+ (void)getRequestHttpURL:(NSString *)url
             completation:(SuccessBlock)success
                  failure:(FailureBlock)netFailure;

+ (void)postRequestHttpURL:(NSString *)url
                 parameter:(id)parameter
              completation:(SuccessBlock)success
                   failure:(FailureBlock)netFailure;

+ (void)postUploadURL:(NSString *)url
           parameters:(NSDictionary *)parameters
             formData:(FormDataBlock)uploadData
             progress:(ProgressBlock)progress
         completation:(SuccessBlock)success
              failure:(FailureBlock)failure;

+ (void)requestWithUrl:(NSString *)url requestType:(HttpRequestType)requestType parameter:(NSDictionary *)parameter completation:(SuccessBlock)success failure:(FailureBlock)failure;
@end
