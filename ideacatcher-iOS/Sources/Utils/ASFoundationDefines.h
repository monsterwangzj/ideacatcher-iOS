//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#ifndef ASFoundation_ASFoundationDefines_h
#define ASFoundation_ASFoundationDefines_h

// double/float 比较宏定义
#define __MIN_FLOATVALUE__				(0.00001)
#define IS_FLOAT_ZREO(f)				((f) > - __MIN_FLOATVALUE__ && (f) < __MIN_FLOATVALUE__)
#define IS_FLOAT_EQUALS(f1, f2)			(IS_FLOAT_ZREO((f1)-(f2)))
#define IS_FLOAT_GREATER(f1, f2)		(((f1)-(f2)) > __MIN_FLOATVALUE__)
#define IS_FLOAT_LESS(f1, f2)			(((f1)-(f2)) < - __MIN_FLOATVALUE__)
#define IS_FLOAT_LESSEQUALS(f1, f2)		(IS_FLOAT_LESS(f1, f2) || IS_FLOAT_EQUALS(f1, f2))
#define IS_FLOAT_GREATEREQUALS(f1, f2)	(IS_FLOAT_GREATER(f1, f2) || IS_FLOAT_EQUALS(f1, f2))

#define DECLARE_UNUSED

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define IsStringValid(_str) (_str && [_str isKindOfClass:[NSString class]] && ([_str length] > 0))

#define IsArrayValid(_array) (_array && [_array isKindOfClass:[NSArray class]] && ([_array count] > 0))

#define IsDictionaryValid(__dic) (__dic && [__dic isKindOfClass:[NSDictionary class]] && ([__dic count] > 0))

#define IsDelegateValid(__aDelegate, __aSelector)   (__aDelegate && [__aDelegate respondsToSelector:__aSelector])

#define $(...) ((NSString *)[NSString stringWithFormat:__VA_ARGS__])

#endif
