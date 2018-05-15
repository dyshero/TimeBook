//
//  APPConfig.h
//  p2p
//
//  Created by mokai on 14-10-14.
//  Copyright (c) 2014年 cloudyoo. All rights reserved.
//

#ifndef APPConfig_h
#define APPConfig_h
/***
 ==============
 应用配置
 ==============
 ***/

// 标准的RGBA设置
#define     ColorRGBA(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define     ColorHex(hex)           [UIColor colorWithHexString:hex]

//专色
#define     COLOR_EMPHASIZE         ColorHex(@"ff4634")//强调色
#define     COLOR_EMPHASIZE_LIGHT   ColorHex(@"fe7c2e")//强调色-轻

//专色
#define     COLOR_1             ColorHex(@"42b1ff")//蓝色
#define     COLOR_1_LIGHT       ColorHex(@"49d6ff")
#define     COLOR_2             ColorHex(@"43CD80")//绿
#define     COLOR_2_LIGHT       ColorHex(@"00EE76")
#define     COLOR_3             ColorHex(@"FFD700")//黄
#define     COLOR_3_LIGHT       ColorHex(@"FFFF00")
#define     COLOR_4             ColorHex(@"ff4634")//红
#define     COLOR_4_LIGHT       ColorHex(@"fe7c2e")
#define     COLOR_5             ColorHex(@"8968CD")//紫色
#define     COLOR_5_LIGHT       ColorHex(@"8470FF")
#define     COLOR_6             ColorHex(@"1A1A1A")//黑色
#define     COLOR_6_LIGHT       ColorHex(@"424242")

//无色系
#define     COLOR_NULL_1            ColorHex(@"323232")//重要色
#define     COLOR_NULL_2            ColorHex(@"616263")//普通段落
#define     COLOR_NULL_3            ColorHex(@"909091")//辅助
#define     COLOR_NULL_4            ColorHex(@"b6b8ba")//辅助
#define     COLOR_NULL_5            ColorHex(@"cfd1d3")//失效/不可点击
#define     COLOR_NULL_6            ColorHex(@"e5e9ec")//分隔
#define     COLOR_NULL_7            ColorHex(@"f0f3f5")//底色

//字体
#define     FONT_SIZE_MAX           27      
#define     FONT_SIZE_1             18      //标题
#define     FONT_SIZE_2             16      //内容标题/按钮
#define     FONT_SIZE_3             15      //主要文字/短文本
#define     FONT_SIZE_4             14      //内容文字/长文本
#define     FONT_SIZE_5             12      //次要/辅助/提示
#define     FONT_SIZE_6             11      //注释

//默认图片
#define     DEFAULT_BG              @"default_bg.png"
#define     DEFAULT_FAIL_BG         @"fail.png"

#define     CACHE_WALLPAPER         @"cache_wallpaper"
#define     CACHE_SAMPLEREEL        @"cache_samplereel"

#endif
