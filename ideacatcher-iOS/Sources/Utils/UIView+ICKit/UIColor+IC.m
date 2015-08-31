//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import "UIColor+IC.h"
#import "ASFoundationDefines.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIColor (IC)

+ (NSString *)supportedColorString:(NSString *)colorString {
    return [colorString hasPrefix:@"#"] ? [colorString substringFromIndex:1] : colorString;
}

+ (UIColor *)colorWithRGBString:(NSString *)rgb {
    return [UIColor colorWithHexRGB:[UIColor supportedColorString:rgb]];
}



+ (BOOL)asIsCssColorStr:(NSString *)cssColorStr
{
    if (![cssColorStr isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    BOOL isCssColorStr = [cssColorStr hasPrefix:@"#"] || [cssColorStr hasPrefix:@"rgba("];
    
    if (!isCssColorStr) {
        Class clz = [UIColor class];
        SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", cssColorStr]);
        isCssColorStr = [clz respondsToSelector:colorSel];
    }
    
    return isCssColorStr;
}

+ (UIColor *)colorWithHexRGB:(NSString *)hex {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte = 0, greenByte = 0, blueByte = 0;
    CGFloat alpha = 1.0;
    
    if (nil != hex)
    {
        NSScanner *scanner = [NSScanner scannerWithString:hex];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    
    BOOL hasAlpha = (hex.length == 8);
    if (hasAlpha) {
        redByte = (unsigned char) (colorCode >> 24);
        greenByte = (unsigned char) (colorCode >> 16);
        blueByte = (unsigned char) (colorCode >> 8); // masks off high bits
        alpha = ((float)(colorCode & 0xff)) / 255;
    }
    else {
        redByte = (unsigned char) (colorCode >> 16);
        greenByte = (unsigned char) (colorCode >> 8);
        blueByte = (unsigned char) (colorCode); // masks off high bits
    }
    
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alpha];
    
    return result;
}

- (NSString *)hexString
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor *)colorWithRGB:(int)rgb {
	return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0f
                           green:((rgb & 0xFF00) >> 8) / 255.0f
                            blue:((rgb & 0xFF)) / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;
    
    if (alpha > 1.0 || alpha < 0.0)
    {
        alpha = 1.0;
    }
    
    return [self colorWithRed:r green:g blue:b alpha:alpha];
}

- (unsigned int)asIntValue
{
    CGFloat component[4] = {0, 0, 0, 0};
    [self getRed:component green:(component + 1) blue:(component + 2) alpha:(component + 3)];
    unsigned int intValue = ((unsigned int)(component[0] * 255) << 24) | ((unsigned int)(component[1] * 255) << 16) | ((unsigned int)(component[2] * 255) << 8) | ((unsigned int)(component[3] * 255));
    return intValue;
}

@end
