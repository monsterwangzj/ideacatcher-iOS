//
// Created by zhaojun.wzj on 8/30/15.
// Copyright (c) 2015 softwisdom. All rights reserved.
//

#import "LoginUITextField.h"

@implementation LoginUITextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x, bounds.origin.y + 4, bounds.size.width - 10, bounds.size.height);//更好理解些
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - 10, bounds.size.height);//更好理解些
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    // [[UIColor orangeColor] setFill];

    [[UIColor grayColor] setFill];
    UIFont *font = [UIFont systemFontOfSize:12];
    [[self placeholder] drawInRect:rect withFont:font];
}

@end