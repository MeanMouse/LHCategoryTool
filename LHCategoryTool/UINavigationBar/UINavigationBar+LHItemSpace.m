//
//  UINavigationBar+LHItemSpace.h
//  LHCategoryTool
//
//  Created by 梁辉 on 2018/2/1.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import "UINavigationBar+LHItemSpace.h"
#import "NSObject+LHRuntime.h"
#import <UIKit/UIKit.h>

#ifndef deviceVersion
#define deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

static BOOL sx_disableFixSpace = NO;

@implementation UIImagePickerController (LHItemSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillAppear:)
                                     swizzledSel:@selector(sx_viewWillAppear:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillDisappear:)
                                     swizzledSel:@selector(sx_viewWillDisappear:)];
    });
}

- (void)sx_viewWillAppear:(BOOL)animated {
    sx_disableFixSpace = YES;
    [self sx_viewWillAppear:animated];
    
}

- (void)sx_viewWillDisappear:(BOOL)animated{
    sx_disableFixSpace = NO;
    [self sx_viewWillDisappear:animated];
}

@end

@implementation UINavigationBar (SXFixSpace)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews)
                                     swizzledSel:@selector(sx_layoutSubviews)];
    });
}

- (void)sx_layoutSubviews{
    [self sx_layoutSubviews];

    if (deviceVersion >= 11 && sx_disableFixSpace) {//需要调节
        self.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = sx_defaultFixSpace;
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);//可修正iOS11之后的偏移
                break;
            }
        }
    }
}

@end

@implementation UINavigationItem (LHItemSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(setLeftBarButtonItem:)
                                     swizzledSel:@selector(sx_setLeftBarButtonItem:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setLeftBarButtonItems:)
                                     swizzledSel:@selector(sx_setLeftBarButtonItems:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItem:)
                                     swizzledSel:@selector(sx_setRightBarButtonItem:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItems:)
                                     swizzledSel:@selector(sx_setRightBarButtonItems:)];
    });
    
}

- (void)sx_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    
    if (deviceVersion >= 11) {
        [self sx_setLeftBarButtonItem:leftBarButtonItem];
    } else {
          if (sx_disableFixSpace && leftBarButtonItem) {//存在按钮且需要调节
              [self setLeftBarButtonItems:@[leftBarButtonItem]];
          } else {//不存在按钮,或者不需要调节
            [self sx_setLeftBarButtonItem:leftBarButtonItem];
        }
    }
}

- (void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    
    if (leftBarButtonItems.count) {
        if (deviceVersion >= 11) {
            
            [self sx_setLeftBarButtonItems:leftBarButtonItems];
        } else {
            
            NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:(sx_disableFixSpace) ?(sx_defaultFixSpace-16) : 0]];//可修正iOS11之前的偏移
            [items addObjectsFromArray:leftBarButtonItems];
            [self sx_setLeftBarButtonItems:items];
        }
    } else {
        
        [self sx_setLeftBarButtonItems:leftBarButtonItems];
    }
}

- (void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    
    if (deviceVersion >= 11) {
        
        [self sx_setRightBarButtonItem:rightBarButtonItem];
    } else {
        if (sx_disableFixSpace && rightBarButtonItem) {//存在按钮且需要调节
            
            [self setRightBarButtonItems:@[rightBarButtonItem]];
        } else {//不存在按钮,或者不需要调节
            
            [self sx_setRightBarButtonItem:rightBarButtonItem];
        }
    }
}

- (void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    if (rightBarButtonItems.count) {
        if (deviceVersion >= 11) {
            
            [self sx_setRightBarButtonItems:rightBarButtonItems];
        } else {
            
            NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:(sx_disableFixSpace) ?(sx_defaultFixSpace-16) : 0]];
            //可修正iOS11之前的偏移
            [items addObjectsFromArray:rightBarButtonItems];
            [self sx_setRightBarButtonItems:items];
        }
        
    } else {
        [self sx_setRightBarButtonItems:rightBarButtonItems];
    }
}

/**
 *  ios11 失效
 */
- (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end
