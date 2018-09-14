//
//  UINavigationBar+Setting.h
//  YykqClinet
//
//  Created by 梁辉 on 2018/2/1.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (LHTool)

/** @brief 导航栏透明 */
- (void)translucent;

/** @brief 导航栏不透明 */
- (void)notTranslucent;

/** @brief 隐藏导航栏底部的黑线 */
- (void)hiddenNavigationBarLine;

/** @brief 显示导航栏底部的黑线 */
- (void)showNavigationBarLine;

/**
 *  @brief 根据颜色和颜色透明度设置背景图片
 *  @param color  颜色
 *  @param colorAlpha  颜色透明度
 */
- (void)setBackgroundImageWithColor:(UIColor *)color colorAlpha:(float)colorAlpha;

/**
 *  @brief 设置背景图片，是否隐藏阴影
 *  @param backgroundImage  背景图片
 *  @param doHideShadow  是否隐藏阴影
 */
- (void)setBackgroundImage:(UIImage *)backgroundImage doHideShadow:(BOOL)doHideShadow;

@end
