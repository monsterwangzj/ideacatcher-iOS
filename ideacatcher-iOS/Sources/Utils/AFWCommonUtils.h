//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFWCommonUtils : NSObject

+ (void)disableMultiTouchInView:(UIView *)view;

+ (UIImageView *)addLineToView:(UIView *)view
                    Horizontal:(BOOL)isHorizontal
                      Position:(CGPoint)position
                        Length:(float)length
                         Color:(UIColor*)color;

+ (UIImageView *)addLineToView:(UIView *)view
                    Horizontal:(BOOL)isHorizontal
                      Position:(CGPoint)position
                        Length:(float)length
                        Height:(float)height
                         Color:(UIColor*)color;

+ (UIImageView *)addLineToView:(UIView *)view
                    Horizontal:(BOOL)isHorizontal
                      Position:(CGPoint)position
                        Length:(float)length
                        Height:(float)height
                         Color:(UIColor*)color
                         ALPHA:(CGFloat)alpha;

@end
