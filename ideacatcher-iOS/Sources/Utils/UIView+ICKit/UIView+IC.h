//
// Created by zhaojun.wzj on 8/24/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ASUIViewTraverseBlock)(id view, int depth, BOOL* shouldStop);

@interface UIView (IC)

@property(nonatomic /* override */) CGFloat asLeft;

@property(nonatomic /* override */) CGFloat asTop;

@property (nonatomic /* override */) CGFloat asRight;

@property (nonatomic /* override */) CGFloat asBottom;

@property (nonatomic /* override */) CGFloat asWidth;

@property (nonatomic /* override */) CGFloat asHeight;

@property (nonatomic /* override */) CGFloat asCenterX;

@property (nonatomic /* override */) CGFloat asCenterY;

@property (nonatomic /* override */) CGPoint asOrigin;

@property (nonatomic /* override */) CGSize asSize;

@property (nonatomic, readonly) CGFloat asBoundsWidth;
@property (nonatomic, readonly) CGFloat asBoundsHeight;

- (void)setPixelAlignFrame:(CGRect )rect;

/**
*  Returns true if th receiver or its ascent views are hidden or alpha=0
*
*  @since 4.2
*/
@property (nonatomic, readonly) BOOL asInvisibleInHierarchy;

+ (id)asInvokeBlock:(id(^)(void))block enableViewAnimation:(BOOL)enableViewAnimation;

- (BOOL)asTranslatesAutoresizingMaskIntoConstraints;
- (void)asSetTranslatesAutoresizingMaskIntoConstraints:(BOOL)flag;

- (void)asRemoveAllSubviews;

- (void)asTraverseSubviewsWithBlock:(ASUIViewTraverseBlock)block;
- (UIView *)asFindParent:(BOOL(^)(UIView *view, UIView *parent))filter;

//- (UIView *)asSnapshotView;

- (void)asInsertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
- (void)asInsertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
- (void)asInsertSubview:(UIView *)view belowView:(UIView *)topView aboveView:(UIView*)bottomView;

- (NSArray *)asSubviewsOfClass:(Class)viewClass;

/**
* invoke layoutSubview in this runloop
*/
- (void)asLayoutSubviewsImmediately;

//- (UIImage *)asSnapshotImage;
/**
*  same as -[self asSnapshotImageWithFrame:frame shouldTryiOS7Method:NO]
*
*  @since 4.1
*/
//- (UIImage *)asSnapshotImageWithFrame:(CGRect)frame;
//- (UIImage *)asSnapshotImageWithFrame:(CGRect)frame shouldTryiOS7Method:(BOOL)shouldTryiOS7Method;

- (void)asTraverseSuperViewWithBlock:(ASUIViewTraverseBlock)block;


- (void)asSetDelaysContentTouchesInSubviews:(BOOL)shouldDelay;

- (UIView *)findFirstResponder;

@end