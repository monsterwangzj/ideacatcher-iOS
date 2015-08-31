//
// Created by zhaojun.wzj on 8/22/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

int ASInt(id obj, int defaultValue);
double ASDouble(id obj, double defaultValue);
float ASFloat(id obj, float defaultValue);
BOOL ASBool(id obj, BOOL defaultValue);
NSString * ASString(NSString * obj, NSString * defaultString);
NSArray * ASArray(NSArray * obj, NSArray * defaultValue);
NSDictionary * ASDictionary(NSDictionary * obj, NSDictionary * defaultValue);
NSInteger ASCGFloatIntegral(CGFloat cgfloat);
CGPoint ASCGPointIntegral(CGPoint point);

NSArray * ASArraySlice(NSArray * array, NSUInteger begin, NSUInteger length);

NSString *ASShortTimeStr(NSTimeInterval timeInterval);
NSString *AFWNewsDetailTime(NSTimeInterval timeInterval);
NSString *AFWNewsListTime(NSTimeInterval timeInterval);
NSString *AFWNewsBulletinListTime(NSTimeInterval timeInterval);
NSString *ASResearchReportTimeStr(NSTimeInterval timeInterval);
NSString *ASMessageTimeStr(NSTimeInterval timeInterval);
NSString *ASRoundingAfterPoint(NSString *price, int position);

#define AS_SHORT_CALL_STACK(len) (ASArraySlice([NSThread callStackSymbols], 0, (len)))
static inline NSString *ASNonNilString(NSString * obj)
{
    return [obj isKindOfClass:[NSString class]] ? obj : @"";
}

static inline NSArray *ASNonNilArray(NSArray * obj)
{
    return [obj isKindOfClass:[NSArray class]] ? obj : @[];
}

static inline NSDictionary *ASNonNilDictionary(NSDictionary * obj)
{
    return [obj isKindOfClass:[NSDictionary class]] ? obj : @{};
}

///-----------------------------------------------------------------------------
@interface ASWeakObject : NSObject
@property(nonatomic, weak, readonly) id object;
- (instancetype)initWithObject:(id)obj;
@end

typedef id(^ASLoadBlock)(void);
///-----------------------------------------------------------------------------
@interface ASCache : NSCache
- (id)asObjectForKey:(id)key createIfMissed:(ASLoadBlock)block;
@end


///-----------------------------------------------------------------------------
@interface NSMutableOrderedSet (AliStock)
- (void)asAddObject:(id)object;
- (void)asRemoveObject:(id)object;
@end

///-----------------------------------------------------------------------------
@interface NSArray (AliStock)

- (id)asObjectAtIndex:(NSUInteger)index;
- (NSArray *)asFilteredArrayWithBlock:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (NSArray *)asSortedArrayWithAscending:(BOOL)ascending forKey:(NSString *)key, ...;
- (NSArray *)asSortedArrayWithArray:(NSArray *)array ascending:(BOOL)ascending forKey:(NSString *)key, ...;
@end

///-----------------------------------------------------------------------------
@interface NSMutableArray (AliStock)
- (void)asAddObject:(id)object;
- (void)alignToCount:(NSInteger)count creation:(id(^)())creation deletion:(void(^)(id object))deletion;
- (void)alignToArray:(NSArray *)array creation:(id(^)())creation deletion:(void(^)(id object))deletion;
@end

///-----------------------------------------------------------------------------
#ifdef __cplusplus
extern "C" {
#endif
///-----------------------------------------------------------------------------
//    void ASSetWeakAssociatedObject(id object, const void *key, id value);
//    id ASGetWeakAssociatedObject(id object, const void * key);
#ifdef __cplusplus
}
#endif

