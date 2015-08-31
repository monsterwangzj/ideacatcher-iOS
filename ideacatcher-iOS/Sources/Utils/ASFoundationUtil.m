//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import "ASFoundationUtil.h"
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import "ASCommonMacro.h"

#ifndef AS_D
#define AS_D NSLog
#endif

#ifndef AS_I
#define AS_I NSLog
#endif

#ifndef AS_E
#define AS_E NSLog
#endif

///-----------------------------------------------------------------------------
///
int ASInt(id obj, int defaultValue)
{
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj intValue];
    
    AS_D(@"NOTE: obj[%@] is not a string or a number, returns defaultValue: %d", obj, defaultValue);
    return defaultValue;
}

double ASDouble(id obj, double defaultValue)
{
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj doubleValue];
    
    AS_D(@"NOTE: obj[%@] is not a string or a number, returns defaultValue: %.1f", obj, defaultValue);
    return defaultValue;
}

float ASFloat(id obj, float defaultValue)
{
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]])
        return [obj floatValue];
    
    AS_D(@"NOTE: obj[%@] is not a string or a number, returns defaultValue: %.1f", obj, defaultValue);
    return defaultValue;
}

BOOL ASBool(id obj, BOOL defaultValue)
{
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) {
        return [obj boolValue];
    }
    
//    AS_D(@"NOTE: obj[%@] is not a string or a number, returns defaultValue: %d", obj, defaultValue);
    return defaultValue;
}

NSString * ASString(NSString *value, NSString *defaultString)
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *)value;
        return [num stringValue];
    }
    
    if (defaultString && ![defaultString isKindOfClass:[NSString class]])
    {
//        AS_W(@"defaultString is not a valid string instance, empty string will be used");
        defaultString = @"";
    }
    
    return defaultString;
}

NSArray * ASArray(NSArray * obj, NSArray * defaultValue)
{
    if ([obj isKindOfClass:[NSArray class]])
        return obj;
    
    if (defaultValue && ![defaultValue isKindOfClass:[NSArray class]])
    {
//        AS_W(@"defaultValue is not a valid array instance, empty array will be used");
        defaultValue = @[];
    }
    
//    AS_D(@"NOTE: obj[%@] is not an NSArray, returns defaultValue: %@", obj, defaultValue);
    
    return defaultValue;
}

NSDictionary * ASDictionary(NSDictionary * obj, NSDictionary * defaultValue)
{
    if ([obj isKindOfClass:[NSDictionary class]])
        return obj;
    
    if (defaultValue && ![defaultValue isKindOfClass:[NSDictionary class]])
    {
//        AS_E(@"defaultValue is not a valid dictionary instance, empty dictionary will be used");
        defaultValue = @{};
    }
    
//    AS_D(@"NOTE: obj[%@] is not an NSDictionary, returns defaultValue: %@", obj, defaultValue);
    return defaultValue;
}

NSInteger ASCGFloatIntegral(CGFloat cgfloat)
{
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale == 0) {
        scale = 1;
    }
    
    return ((NSInteger)(cgfloat * scale)) / scale;
}

CGPoint ASCGPointIntegral(CGPoint point)
{
    return CGPointMake(ASCGFloatIntegral(point.x), ASCGFloatIntegral(point.y));
}

NSArray * ASArraySlice(NSArray * array, NSUInteger begin, NSUInteger length)
{
    @try
    {
        array = ASNonNilArray(array);
        
        NSArray * ret = nil;
        
        if (begin < [array count] && length > 0)
        {
            NSUInteger len = MIN([array count] - begin, length);
            ret = [array subarrayWithRange:NSMakeRange(begin, len)];
        }
        
        return ASNonNilArray(ret);
    }
    @catch (NSException *exception)
    {
//        AS_E(@"failed to slice array(%@), begin %@, %@, %@", @(array.count), @(begin), @(length), exception);
        return @[];
    }
}

NSString *GetWeekString(int weekOfTargetDate)
{
    NSString *s = nil;
    switch (weekOfTargetDate) {
        case 1:
            s = @"星期天";
            break;
            
        case 2:
            s = @"星期一";
            break;
            
        case 3:
            s = @"星期二";
            break;
            
        case 4:
            s = @"星期三";
            break;
            
        case 5:
            s = @"星期四";
            break;
            
        case 6:
            s = @"星期五";
            break;
            
        case 7:
            s = @"星期六";
            break;
            
        default:
            break;
    }
    
    return s;
}

NSString *ASShortTimeStr(NSTimeInterval timeInterval)
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:targetDate];
	int yearOfTargetDate = (int)components.year;
	int monOfTargetDate = (int)components.month;
	int dayOfTargetDate = (int)components.day;
    int hourOfTargetDate = (int)components.hour;
    int minOfTargetDate = (int)components.minute;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComp = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:nowDate];
    NSInteger yearOfToday = nowComp.year;
    NSInteger dayOfToday = nowComp.day;
    
    int now = [nowDate timeIntervalSince1970];

    int times = now - (int)timeInterval;
    if (times < 0) {
        return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
    }
    
    NSString *s = nil;
    if (times >= 0 && times < 60) {
        s = [NSString stringWithFormat:@"刚刚"];
    }
    else if (times >= 60 && times < 60 * 60) {
        s = [NSString stringWithFormat:@"%d分钟前", times / 60];
    }
    else if (times >= 60 * 60 && times < 60 * 60 * 24) {
        if (dayOfToday != dayOfTargetDate) {
            s = [NSString stringWithFormat:@"昨天 %02d:%02d", hourOfTargetDate, minOfTargetDate];
        }
        else {
            s = [NSString stringWithFormat:@"%d小时前", times / (60 * 60)];
        }
    }
    else if (times >= 60 * 60 * 24 && times < 60 * 60 * 24 * 2) {
        if (dayOfToday - dayOfTargetDate == 1) {
            s = [NSString stringWithFormat:@"昨天 %02d:%02d", hourOfTargetDate, minOfTargetDate];
        }
        else if (dayOfToday - dayOfTargetDate > 1) {
            s = [NSString stringWithFormat:@"前天 %02d:%02d", hourOfTargetDate, minOfTargetDate];
        }
        else {
            s = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
    }
    else if (times >= 60 * 60 * 24 * 2 && times < 60 * 60 * 24 * 3) {
        if (dayOfToday - dayOfTargetDate == 2) {
            s = [NSString stringWithFormat:@"前天 %02d:%02d", hourOfTargetDate, minOfTargetDate];
        }
        else if (dayOfToday - dayOfTargetDate > 2) {
            if (yearOfToday != yearOfTargetDate) {
                s = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
            }
            else {
                s = [NSString stringWithFormat:@"%02d-%02d %02d:%02d",
                     monOfTargetDate,
                     dayOfTargetDate,
                     hourOfTargetDate,
                     minOfTargetDate];
            }
        }
        else {
            s = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
    }
    else if (times >= 60 * 60 * 24 * 3) {
        if (yearOfToday != yearOfTargetDate) {
            s = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
        else {
            s = [NSString stringWithFormat:@"%02d-%02d %02d:%02d",
                 monOfTargetDate,
                 dayOfTargetDate,
                 hourOfTargetDate,
                 minOfTargetDate];
        }
    }
    
    return s;
}


NSString *AFWNewsDetailTime(NSTimeInterval timeInterval)
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:targetDate];
    int yearOfTargetDate = (int)components.year;
    int monOfTargetDate = (int)components.month;
    int dayOfTargetDate = (int)components.day;
    int hourOfTargetDate = (int)components.hour;
    int minOfTargetDate = (int)components.minute;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComp = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                            fromDate:nowDate];
    NSInteger yearOfToday = nowComp.year;
    NSInteger dayOfToday = nowComp.day;
    
    int now = [nowDate timeIntervalSince1970];
    
    int times = now - (int)timeInterval;
    if (times < 0) {
        return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
    }
    
    NSString *s = nil;
   
    if (times < 60 * 60 * 24)
    {
        if (dayOfToday != dayOfTargetDate)
        {
            //昨天
            s = [NSString stringWithFormat:@"%02d-%02d %02d:%02d",monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
        else
        {
            //今天
            s = [NSString stringWithFormat:@"今天 %02d:%02d", hourOfTargetDate, minOfTargetDate];
        }
    }
    else if (times >= 60 * 60 * 24)
    {
        if (yearOfToday != yearOfTargetDate) {
            //往年
            s = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
        else
        {
            //当年
            s = [NSString stringWithFormat:@"%02d-%02d %02d:%02d",
                 monOfTargetDate,
                 dayOfTargetDate,
                 hourOfTargetDate,
                 minOfTargetDate];
        }
    }
    
    return s;
}


NSString *AFWNewsListTime(NSTimeInterval timeInterval)
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:targetDate];
    int yearOfTargetDate = (int)components.year;
    int monOfTargetDate = (int)components.month;
    int dayOfTargetDate = (int)components.day;
    int hourOfTargetDate = (int)components.hour;
    int minOfTargetDate = (int)components.minute;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComp = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                            fromDate:nowDate];
    NSInteger yearOfToday = nowComp.year;
    NSInteger dayOfToday = nowComp.day;
    
    int now = [nowDate timeIntervalSince1970];
    
    int times = now - (int)timeInterval;
    if (times < 0) {
        return [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
    }
    
    NSString *s = nil;
    if (times >= 0 && times < 60)
    {
        s = [NSString stringWithFormat:@"%d秒前", times];
    }
    else if (times >= 60 && times < 60 * 60)
    {
        s = [NSString stringWithFormat:@"%d分钟前", times / 60];
    }
    else if (times >= 60 * 60 && times < 60 * 60 * 24) {
        if (dayOfToday != dayOfTargetDate)
        {
            //昨天
            s = [NSString stringWithFormat:@"%02d-%02d %02d:%02d",monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
        else
        {
            //今天
            s = [NSString stringWithFormat:@"%d小时前", times / (60 * 60)];
        }
    }
    else if (times >= 60 * 60 * 24)
    {
        if (yearOfToday != yearOfTargetDate) {
            //往年
            s = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
        else
        {
            //当年
            s = [NSString stringWithFormat:@"%02d-%02d %02d:%02d",
                 monOfTargetDate,
                 dayOfTargetDate,
                 hourOfTargetDate,
                 minOfTargetDate];
        }
    }
    
    return s;
}

NSString *AFWNewsBulletinListTime(NSTimeInterval timeInterval)
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:targetDate];
    int yearOfTargetDate = (int)components.year;
    int monOfTargetDate = (int)components.month;
    int dayOfTargetDate = (int)components.day;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComp = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                            fromDate:nowDate];
    NSInteger yearOfToday = nowComp.year;
    
    int now = [nowDate timeIntervalSince1970];
    
    int times = now - (int)timeInterval;
    
    NSString *s = nil;
    
    if (times >= 60 * 60 * 24)
    {
        if (yearOfToday != yearOfTargetDate) {
            
            //往年
            s = [NSString stringWithFormat:@"%d-%02d-%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate];
        } else {
            
            //当年
            s = [NSString stringWithFormat:@"%02d-%02d", monOfTargetDate, dayOfTargetDate];
        }
    }
    
    return s;
}


NSString *ASResearchReportTimeStr(NSTimeInterval timeInterval)
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                               fromDate:targetDate];
    int yearOfTargetDate = (int)components.year;
    int monOfTargetDate = (int)components.month;
    int dayOfTargetDate = (int)components.day;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComp = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                            fromDate:nowDate];
    NSInteger yearOfToday = nowComp.year;
    
    NSString *timeStr = nil;
    if (yearOfTargetDate == yearOfToday) {
        timeStr = [NSString stringWithFormat:@"%02d-%02d", monOfTargetDate, dayOfTargetDate];
    }
    else {
        timeStr = [NSString stringWithFormat:@"%d-%02d-%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate];
    }
    
    return timeStr;
}

NSString *ASMessageTimeStr(NSTimeInterval timeInterval)
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSCalendarUnitWeekday
                                               fromDate:targetDate];
    int yearOfTargetDate = (int)components.year;
    int monOfTargetDate = (int)components.month;
    int weekOfTargetDate = (int)components.weekday;
    int dayOfTargetDate = (int)components.day;
    int hourOfTargetDate = (int)components.hour;
    int minOfTargetDate = (int)components.minute;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowComp = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                            fromDate:nowDate];
    NSInteger yearOfToday = nowComp.year;
    NSInteger monOfToday = nowComp.month;
    NSInteger dayOfToday = nowComp.day;
    
    NSString *s = nil;
    //当年
    if (yearOfToday == yearOfTargetDate) {
        
        int now = [nowDate timeIntervalSince1970];
        //当日零点
        int today = now - nowComp.second - nowComp.minute*60 - nowComp.hour*60*60;
        int times = today - (int)timeInterval;

        //当天
        if (monOfToday == monOfTargetDate && dayOfToday == dayOfTargetDate) {
            s = [NSString stringWithFormat:@"今天 %02d:%02d", hourOfTargetDate, minOfTargetDate];
        }
        //第二天
        else if (times < 60*60*24) {
            s = [NSString stringWithFormat:@"昨天 %02d:%02d", hourOfTargetDate, minOfTargetDate];
        }
        //7天内
        else if (times < 60*60*24*7) {
            s = [NSString stringWithFormat:@"%@ %02d:%02d", GetWeekString(weekOfTargetDate), hourOfTargetDate, minOfTargetDate];
        }
        //当年
        else {
            s = [NSString stringWithFormat:@"%02d-%02d %02d:%02d", monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
        }
    }
    //跨年
    else {
        s = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d", yearOfTargetDate, monOfTargetDate, dayOfTargetDate, hourOfTargetDate, minOfTargetDate];
    }
    return s;
}

// 四舍五入，精确到小数点后几位。解决了%.4f不四舍五入的问题（1.101350->1.1013）
NSString *ASRoundingAfterPoint(NSString *price, int position)
{
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;

    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *result = [NSString stringWithFormat:@"%@", roundedOunces];
    NSUInteger dotLocation = [result rangeOfString:@"."].location;
    if (dotLocation != NSNotFound) {
        while ([result substringFromIndex:(dotLocation + 1)].length < position) {
            result = [result stringByAppendingString:@"0"];
        }
    }
    if (!result || [result isEqualToString:@"NAN"]) {
        result = GangGang;
    }
    return result;
}

///-----------------------------------------------------------------------------
/**
 *  If you want to use ASWeakObject as a key in an NSDictionary, you also need to implement -copyWithZone:
 */
@implementation ASWeakObject

- (instancetype)initWithObject:(id)obj
{
    self = [super init];
    if (self)
    {
        _object = obj;
    }
    
    return self;
}

@end

///-----------------------------------------------------------------------------
@interface ASCache()
@property (nonatomic, strong) NSMutableSet *allCacheKeys;
@end

@implementation ASCache

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_UIApplicationDidReceiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  Explicitly remove all cached entried on memory warning, which is not done by system on iOS7
 *
 *
 *  @since 3.3
 */
- (void)p_UIApplicationDidReceiveMemoryWarningNotification:(NSNotification *)notification
{
    [self removeAllObjects];
}

- (id)asObjectForKey:(id)key createIfMissed:(ASLoadBlock)block {
    if (!key) {
        AS_E(@"nil key");
        return nil;
    }
    id object = [self objectForKey:key];
    if (block) {
        if (object) {
        }else{
            object = block();
            if (object) {
                [self setObject:object forKey:key];
            }
        }
    }
    
    return object;
}

#pragma mark -
#pragma mark overrides

- (void)setObject:(id)obj forKey:(id)key {
    @synchronized(self) {
        [super setObject:obj forKey:key];
        [self.allCacheKeys addObject:key];
    }
}

- (void)removeAllObjects {
    @synchronized(self) {
        [super removeAllObjects];
        [_allCacheKeys removeAllObjects];
    }
}

- (void)removeObjectForKey:(id)key {
    @synchronized(self) {
        [super removeObjectForKey:key];
        [_allCacheKeys removeObject:key];
    }
}

#pragma mark -
#pragma mark lazy loading allCacheKeys;
- (NSMutableSet *)allCacheKeys {
    if (!_allCacheKeys) {
        _allCacheKeys = [NSMutableSet set];
    }
    return _allCacheKeys;
}

#pragma mark -
#pragma mark
- (NSString *)description {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<%@: %p>\n", NSStringFromClass([self class]), self];
    for (NSString *cacheKey in _allCacheKeys) {
        [string appendFormat:@"%@ => %@\n", cacheKey, [self objectForKey:cacheKey]];
    }
    return string;
}

@end

///-----------------------------------------------------------------------------
@implementation NSMutableOrderedSet (AliStock)

- (void)asAddObject:(id)object
{
    if (object){
        [self addObject:object];
    }
}

- (void)asRemoveObject:(id)object
{
    if (object){
        [self removeObject:object];
    }
}

@end

///-----------------------------------------------------------------------------
@implementation NSArray (AliStock)

- (id)asObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

- (NSArray *)asFilteredArrayWithBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    NSMutableArray *list = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id filteredObj = block(obj, idx, stop);
        if (filteredObj) {
            [list addObject:filteredObj];
        }
    }];
    
    return list;
}

- (NSArray *)asSortedArrayWithAscending:(BOOL)ascending forKey:(NSString *)key, ...
{
    NSMutableArray *sdArray = [NSMutableArray arrayWithCapacity:0];
    va_list parameters;
    va_start(parameters, key);
    for (NSString *string = key; string != nil; string = va_arg(parameters, NSString *)) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
        [sdArray addObject:sd];
    }
    va_end(parameters);
    
    NSArray *sortedArray = [self sortedArrayUsingDescriptors:sdArray];
    return sortedArray;
}

- (NSArray *)asSortedArrayWithArray:(NSArray *)array ascending:(BOOL)ascending forKey:(NSString *)key, ...
{
    NSMutableArray *sdArray = [NSMutableArray arrayWithCapacity:0];
    va_list parameters;
    va_start(parameters, key);
    for (NSString *string = key; string != nil; string = va_arg(parameters, NSString *)) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
        [sdArray addObject:sd];
    }
    va_end(parameters);
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sdArray];
    return sortedArray;
}
@end

@implementation NSMutableArray (AliStock)

- (void)asAddObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

- (void)alignToArray:(NSArray *)array creation:(id(^)())creation deletion:(void(^)(id object))deletion
{
    [self alignToCount:array.count creation:creation deletion:deletion];
}

- (void)alignToCount:(NSInteger)count creation:(id(^)())creation deletion:(void(^)(id object))deletion
{
    NSInteger countToAdd = count - self.count;
    if (countToAdd > 0) {
        for (NSInteger i = 0; i < countToAdd; i++) {
            [self asAddObject:creation()];
        }
    } else if (countToAdd < 0) {
        NSInteger countToRemove = -countToAdd;
        for (NSInteger i = 0; i < countToRemove; i++) {
            id object = [self lastObject];
            deletion(object);
            [self removeLastObject];
        }
    }
}

@end

