//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(r, g, b, a) 	[UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define RGB(r, g, b) 		RGBA(r, g, b, 1.0f)
#define HEX(rgb) 			RGB((rgb) >> 16 & 0xff, (rgb) >> 8 & 0xff, (rgb) & 0xff)
#define CssColor(__color) [UIColor asColorWithCSSColor:__color]

@interface UIColor (IC)


+ (BOOL)asIsCssColorStr:(NSString *)cssColorStr;

/**
 *	@brief	创建一个颜色对象。
 *
 *	@param 	inColorString 	形如RRGGBB的十六进制的字符串，其前方未带#号。
 *
 *	@return	颜色对象。
 */
+ (UIColor *)colorWithHexRGB:(NSString *)hex;
- (NSString *)hexString;

/**
 *	@brief	用一个24位的整数生成UIColor
 *
 *	@param 	rgb 	形如0xRRGGBB的16进制整数
 *
 *	@return	The color object.
 */
+ (UIColor *)colorWithRGB:(int)rgb;

/**
 *  @brief  用两个整数生成UIColor
 *
 *  @param hexValue 颜色的rgb值，0xRRGGBB
 *  @param alpha    透明度，0～1
 *
 *  @return 颜色对象
 */
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;


/**
 * @brief 生成颜色对应的整数
 * @return like 0xff0000ff (red color)
 */
- (unsigned int)asIntValue;

@end
