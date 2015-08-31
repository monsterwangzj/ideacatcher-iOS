//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

//#import "ASCommonConfig.h"
#ifndef AFWealth_ASCommonMacro_h
#define AFWealth_ASCommonMacro_h

/**
 * Indicates any overrided impl in subclasses should invoke super call
 */
#if __has_attribute(objc_requires_super)
#define AS_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
#define AS_REQUIRES_SUPER
#endif

#if __has_attribute(deprecated)
#define AS_DEPRECATED __attribute__((deprecated))
#else
#define AS_DEPRECATED
#endif


#define NotNilString_DISC(str) str ? str : @""

#define AS_UNUSED(x) ((void)(x))


#define ASDeclareWeakSelf __weak typeof(self) weakSelf = self

#define kRC(s) [ASStyleColor(s) asIntValue]

#define isScreenLandscape(width) \
do { \
return width==[[UIScreen mainScreen] bounds].size.width?YES:NO; \
}while(0)


//判断string是否为空
#define IsStringEmpty(string) (string && [string respondsToSelector:@selector(length)] && [string length] > 0 ? NO : YES)

//将空string替换为--
#define GangGang @"--"

#define ReplaceEmptyString(string) IsStringEmpty(string) ? GangGang : string

#define kASIPhone5ScreenHeight (568)

//图片
#define Boundle_Image(name) [UIImage asImageNamed:(name)]

//屏蔽某个waring
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif
