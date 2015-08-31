//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#ifndef ASCommonUI_ASCommonUIDefines_h
#define ASCommonUI_ASCommonUIDefines_h

#import "ASFoundationDefines.h"

/**
 *	@brief	m是原始值，n是放大或缩小的系数，
 *	@return 最相近的pixel align的值
 */
static inline double BEST_FRAME_VALUE(double m, double n)
{
    if (IS_FLOAT_ZREO(m) || IS_FLOAT_ZREO(n)) {
        return 0;
    }
    
    return roundf(m*n*[UIScreen mainScreen].scale)/[UIScreen mainScreen].scale;
}

#endif
