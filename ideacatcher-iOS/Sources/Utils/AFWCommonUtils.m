//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import "AFWCommonUtils.h"

@implementation AFWCommonUtils

+ (void)disableMultiTouchInView:(UIView *)view
{
    view.exclusiveTouch = YES;
    view.multipleTouchEnabled = NO;
    
    NSArray *subviews = view.subviews;
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.exclusiveTouch = YES;
        view.multipleTouchEnabled = NO;
        [AFWCommonUtils disableMultiTouchInView:view];
    }];
}

+ (UIImageView *)addLineToView:(UIView *)view
                    Horizontal:(BOOL)isHorizontal
                      Position:(CGPoint)position
                        Length:(float)length
                         Color:(UIColor*)color
{
    return [AFWCommonUtils addLineToView:view Horizontal:isHorizontal Position:position Length:length Height:0.5 Color:color];
}

+ (UIImageView *)addLineToView:(UIView *)view
                    Horizontal:(BOOL)isHorizontal
                      Position:(CGPoint)position
                        Length:(float)length
                        Height:(float)height
                         Color:(UIColor*)color {
    return [AFWCommonUtils addLineToView:view Horizontal:isHorizontal Position:position Length:length Height:0.5 Color:color ALPHA:1];
}

+ (UIImageView *)addLineToView:(UIView *)view
                    Horizontal:(BOOL)isHorizontal
                      Position:(CGPoint)position
                        Length:(float)length
                        Height:(float)height
                         Color:(UIColor*)color
                         ALPHA:(CGFloat)alpha {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.x, position.y, isHorizontal?length:height, isHorizontal?height:length)];
    [imageView setBackgroundColor:color];
    imageView.alpha = alpha;
    [view addSubview:imageView];
    return imageView;
}


@end
