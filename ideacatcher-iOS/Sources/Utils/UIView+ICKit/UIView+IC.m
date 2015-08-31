//
// Created by zhaojun.wzj on 8/24/15.
// Copyright (c) 2015 com.softwisdom. All rights reserved.
//

#import "UIView+IC.h"
#import "ASCommonUIDefines.h"

@implementation UIView (IC)

+ (id)asInvokeBlock:(id(^)(void))block enableViewAnimation:(BOOL)enableViewAnimation
{
    id ret = nil;

    if (block){
        if (enableViewAnimation){
            ret = block();
        }else{
            BOOL enabled = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];

            ret = block();

            [UIView setAnimationsEnabled:enabled];
        }
    }

    return ret;
}

- (BOOL)asTranslatesAutoresizingMaskIntoConstraints
{
    if ([self respondsToSelector:@selector(translatesAutoresizingMaskIntoConstraints)]){
        return [self translatesAutoresizingMaskIntoConstraints];
    }

    return NO;
}

- (void)asSetTranslatesAutoresizingMaskIntoConstraints:(BOOL)flag
{
    if ([self respondsToSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:)]){
        [self setTranslatesAutoresizingMaskIntoConstraints:flag];
    }
}

- (void)asRemoveAllSubviews
{
    for (UIView * sub in self.subviews){
        [sub removeFromSuperview];
    }
}

- (void)asTraverseSubviewsWithBlock:(ASUIViewTraverseBlock)block
{
    [self asTraverseSubviewsWithBlock:block depth:0];
}

- (UIView *)asFindParent:(BOOL(^)(UIView *view, UIView *parent))filter
{
    UIView *parent = self.superview;
    if (!parent || !filter) {
        return nil;
    }

    while (parent) {
        BOOL found = filter(self, parent);
        if (found) {
            return parent;
        }

        parent = parent.superview;
    }

    return nil;
}

- (void)asTraverseSubviewsWithBlock:(ASUIViewTraverseBlock)block depth:(int)depth
{
    if (block)
    {
        BOOL shouldStop = NO;
        block(self, depth, &shouldStop);

        if (!shouldStop)
        {
            for (UIView * sub in self.subviews)
                [sub asTraverseSubviewsWithBlock:block depth:(depth + 1)];
        }
    }
}

- (void)asTraverseSuperViewWithBlock:(ASUIViewTraverseBlock)block
{
    [self asTraverseSuperViewWithBlock:block depth:0];
}

- (void)asTraverseSuperViewWithBlock:(ASUIViewTraverseBlock)block depth:(int)depth
{
    if (block)
    {
        BOOL shouldStop = NO;
        block(self, depth, &shouldStop);

        if (!shouldStop)
        {
            [self.superview asTraverseSuperViewWithBlock:block depth:(depth + 1)];
        }
    }
}

//- (UIView *)asSnapshotView
//{
//    UIView * snapshotView;
//
//    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]){
//        snapshotView = [self snapshotViewAfterScreenUpdates:NO];
//    }else{
//        UIImage * image = [self asSnapshotImageWithFrame:self.bounds];
//        snapshotView = [[UIImageView alloc] initWithImage:image];
//    }
//
//    return snapshotView;
//}

- (void)asInsertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
    if (siblingSubview){
        [self insertSubview:view aboveSubview:siblingSubview];
    }else{
        [self addSubview:view];
    }
}

- (void)asInsertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
    if (siblingSubview){
        [self insertSubview:view belowSubview:siblingSubview];
    }else{
        [self addSubview:view];
    }
}

- (void)asInsertSubview:(UIView *)view belowView:(UIView *)topView aboveView:(UIView*)bottomView
{
    if (topView && bottomView && topView.superview == self && bottomView.superview == self){
        [self insertSubview:bottomView belowSubview:topView];
        [self insertSubview:view belowSubview:topView];
    }else{
        [self addSubview:view];
    }
}

- (NSArray *)asSubviewsOfClass:(Class)viewClass
{
    NSArray * subviews = self.subviews;

    NSIndexSet * indices = [subviews indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:viewClass];
    }];

    if (indices){
        return [subviews objectsAtIndexes:indices];
    }else{
        return @[];
    }
}

- (CGFloat)asLeft {
    return self.frame.origin.x;
}

- (void)setAsLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)asTop {
    return self.frame.origin.y;
}

- (void)setAsTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)asRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setAsRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)asBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setAsBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setPixelAlignFrame:(CGRect )rect
{
    CGRect nRect = CGRectMake(BEST_FRAME_VALUE(rect.origin.x, 1), BEST_FRAME_VALUE(rect.origin.y, 1), BEST_FRAME_VALUE(rect.size.width, 1), BEST_FRAME_VALUE(rect.size.height, 1));
    self.frame = nRect;
}

- (CGFloat)asCenterX {
    return self.center.x;
}

- (void)setAsCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)asCenterY {
    return self.center.y;
}

- (void)setAsCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)asWidth {
    return self.frame.size.width;
}

- (void)setAsWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)asHeight {
    return self.frame.size.height;
}

- (void)setAsHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)asOrigin {
    return self.frame.origin;
}

- (void)setAsOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)asSize {
    return self.frame.size;
}

- (void)setAsSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)asBoundsHeight
{
    return self.bounds.size.height;
}

- (CGFloat)asBoundsWidth
{
    return self.bounds.size.width;
}

- (BOOL)asInvisibleInHierarchy
{
    if (self.hidden || self.alpha == 0)
        return YES;
    else
        return [self.superview asInvisibleInHierarchy];
}

/**
* invoke layoutSubview in this runloop
*/
- (void)asLayoutSubviewsImmediately
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//- (UIImage *)asSnapshotImage
//{
//    return [self asSnapshotImageWithFrame:self.bounds];
//}

//- (UIImage *)asSnapshotImageWithFrame:(CGRect)frame
//{
//    return [self asSnapshotImageWithFrame:frame shouldTryiOS7Method:NO];
//}

//- (UIImage *)asSnapshotImageWithFrame:(CGRect)frame shouldTryiOS7Method:(BOOL)shouldTryiOS7Method
//{
//    CGRect rect = self.bounds;
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    if ([self isKindOfClass:[UIScrollView class]]){
//        UIScrollView * scroll = (UIScrollView *) self;
//        CGContextTranslateCTM(context, -scroll.contentOffset.x, -scroll.contentOffset.y);
//    }
//
//    if (shouldTryiOS7Method
//            && [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]
//            && ![[UIDevice currentDevice] asIsIPad]
//            )
//    {
//        /**
//        *  1. using afterScreenUpdates=YES to prevent capturing intermediate animation states
//        *  2. this method also captures web content with 3d CSS transforming
//        *  3. drawViewHierarchyInRect:afterScreenUpdates: is buggy on iPad and causes flickering, so we fallback to renderInContext: for iPad
//        *
//        *  @since 4.1
//        */
//        BOOL captured = [self drawViewHierarchyInRect:rect afterScreenUpdates:YES];
//        if (!captured)
//            AS_W(@"capture may have failed with view %@, %@", self, NSStringFromCGRect(frame));
//    }
//    else
//    {
//        [self.layer renderInContext:context];
//    }
//
//    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    if (CGRectEqualToRect(self.bounds, frame))
//    {
//        return snapshotImage;
//    }
//    else
//    {
//        CGFloat scale = snapshotImage.scale;
//        CGRect cropRect = CGRectMake(CGRectGetMinX(frame) * scale, CGRectGetMinY(frame) * scale, CGRectGetWidth(frame) * scale, CGRectGetHeight(frame) * scale);
//        CGImageRef imageRef = CGImageCreateWithImageInRect(snapshotImage.CGImage, cropRect);
//        UIImage *img = [UIImage imageWithCGImage:imageRef scale:snapshotImage.scale orientation:snapshotImage.imageOrientation];
//        CGImageRelease(imageRef);
//        return img;
//    }
//}

- (void)asSetDelaysContentTouchesInSubviews:(BOOL)shouldDelay
{
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)self setDelaysContentTouches:shouldDelay];
    }

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)subview setDelaysContentTouches:shouldDelay];
        }
        [subview asSetDelaysContentTouchesInSubviews:shouldDelay];
    }
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }

    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }

    return nil;
}

@end