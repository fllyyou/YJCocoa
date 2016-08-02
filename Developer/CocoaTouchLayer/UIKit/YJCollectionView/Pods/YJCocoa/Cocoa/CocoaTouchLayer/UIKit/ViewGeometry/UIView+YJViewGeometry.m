//
//  UIView+YJViewGeometry.m
//  YJViewGeometry
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 16/5/31.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "UIView+YJViewGeometry.h"

@implementation UIView (YJViewGeometry)


#pragma mark .frame.origin.y
- (CGFloat)topFrame {
    return self.frame.origin.y;
}

- (void)setTopFrame:(CGFloat)topFrame {
    CGRect frame = self.frame;
    frame.origin.y = topFrame;
    self.frame = frame;
}

#pragma mark .topFrame + .heightFrame
- (CGFloat)bottomFrame {
    return self.topFrame + self.heightFrame;
}

- (void)setBottomFrame:(CGFloat)bottomFrame {
    self.topFrame = bottomFrame - self.heightFrame;
}

#pragma mark .frame.origin.x
- (CGFloat)leadingFrame {
    return self.frame.origin.x;
}

- (void)setLeadingFrame:(CGFloat)leadingFrame {
    CGRect frame = self.frame;
    frame.origin.x = leadingFrame;
    self.frame = frame;
}

#pragma mark .leadingFrame + .widthFrame
- (CGFloat)trailingFrame {
    return self.leadingFrame + self.widthFrame;
}

- (void)setTrailingFrame:(CGFloat)trailingFrame {
    self.leadingFrame = trailingFrame - self.widthFrame;
}

#pragma mark - .frame.size.width
- (CGFloat)widthFrame {
    return self.frame.size.width;
}

- (void)setWidthFrame:(CGFloat)widthFrame {
    CGRect frame = self.frame;
    frame.size.width = widthFrame;
    self.frame = frame;
}

#pragma mark .frame.size.height
- (CGFloat)heightFrame {
    return self.frame.size.height;
}

- (void)setHeightFrame:(CGFloat)heightFrame {
    CGRect frame = self.frame;
    frame.size.height = heightFrame;
    self.frame = frame;
}

#pragma mark -
- (CGFloat)centerXFrame {
    return self.center.x;
}

- (void)setCenterXFrame:(CGFloat)centerXFrame {
    CGPoint center = self.center;
    center.x = centerXFrame;
    self.center = center;
}

#pragma mark .center.y
- (CGFloat)centerYFrame {
    return self.center.y;
}

- (void)setCenterYFrame:(CGFloat)centerYFrame {
    CGPoint center = self.center;
    center.y = centerYFrame;
    self.center = center;
}

#pragma mark - .frame.origin
- (CGPoint)originFrame {
    return self.frame.origin;
}

- (void)setOriginFrame:(CGPoint)originFrame {
    CGRect frame = self.frame;
    frame.origin = originFrame;
    self.frame = frame;
}

#pragma mark .frame.szie
- (CGSize)sizeFrame {
    return self.frame.size;
}

- (void)setSizeFrame:(CGSize)sizeFrame {
    CGRect frame = self.frame;
    frame.size = sizeFrame;
    self.frame = frame;
}

#pragma mark - Window
#pragma mark .frame.origin in Window
- (CGPoint)originFrameInWindow {
    CGPoint origin = self.originFrame;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *superview = self.superview;
    while (superview && ![superview isEqual:window]) {
        origin.x += superview.originFrame.x;
        origin.y += superview.originFrame.y;
        superview = superview.superview;
    }
    return origin;
}

@end