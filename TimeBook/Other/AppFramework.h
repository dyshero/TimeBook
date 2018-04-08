//
//  NSObject_AppFramework.h
//
//  Created by mokai on 14-7-25.
//  Copyright (c) 2014年 cloudyoo. All rights reserved.
//

#ifndef     AppFramework_Define
#define     AppFramework_Define

#define     KDateFormatYMD          @"yyyy-MM-dd"
#define     KDateFormatYMDHM        @"yyyy-MM-dd HH:mm"
#define     KDateFormatYMDHMS       @"yyyy-MM-dd HH:mm:ss"


/***
 ==============
 系统配置
 ==============
 ***/
#define     IOS_VERSION         [[[UIDevice currentDevice] systemVersion] floatValue]

//定义屏幕的宽高
#define     WIDTH               [[UIScreen mainScreen] bounds].size.width
#define     HEIGHT              [[UIScreen mainScreen] bounds].size.height

//状态栏高度
#define     STATUEBAR_HEIGHT    [[UIApplication sharedApplication] statusBarFrame].size.height
//标签栏高度
#define     TABBAR_HEIGHT       (STATUEBAR_HEIGHT > 20 ? 83 : 49)
//导航栏高度
#define     NAVBAR_HEIGHT       (STATUEBAR_HEIGHT + 44)

/***
 ==============
 宏定义
 ==============
 ***/

//日志
#ifdef DEBUG
#define NSLog(...)      NSLog(__VA_ARGS__)
#define debugLog(...)   NSLog(__VA_ARGS__)
#define debugMethod()   NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#define NSLog(...){}
#endif

//控件对齐
#define     TEXT_ALIGNMENT_CENTER   (IOS_VERSION<6.0 ?UITextAlignmentCenter:NSTextAlignmentCenter )
#define     TEXT_ALIGNMENT_LEFT     (IOS_VERSION<6.0 ?UITextAlignmentLeft:NSTextAlignmentLeft )
#define     TEXT_ALIGNMENT_RIGHT    (IOS_VERSION<6.0 ?UITextAlignmentRight:NSTextAlignmentRight )

//字体
#define     kFont(size)             [UIFont systemFontOfSize:size]
#define     kFontBold(size)         [UIFont boldSystemFontOfSize:size]
//字符
#define     str_isblank(str)        (str==nil || [str.description isEqual:@""])//是否为nil或空字符
#define     str_isnotblank(str)     (!str_isblank(str))
#define     str_blank(str)          (str_isblank(str)?@"":str_trim(str))//如果为nil则返回空字符
#define     str_default(str,val)    (str_isblank(str)?val:str)//如果为nil则返回val
#define     str_trim(str)           [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]//去掉两边空格
//数组
#define    arr_isblank(arr)         (arr==nil || [arr.description isEqual:@""]||(arr.count==0))//是否为空数组
#define    arr_blank(arr)           (arr_isblank(arr)?@[]:arr)//如果为nil则返回空数组


#endif
