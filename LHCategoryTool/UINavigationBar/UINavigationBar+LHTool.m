//
//  UINavigationBar+LHTool.m
//  LHCategoryTool
//
//  Created by 梁辉 on 2018/2/1.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import "UINavigationBar+LHTool.h"
#import "UIImage+LHTool.h"

@implementation UINavigationBar (LHTool)

/** @brief 导航栏透明 */
- (void)translucent
{
    
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
}

/** @brief 导航栏不透明 */
- (void)notTranslucent
{
    
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    if ([self respondsToSelector:@selector(shadowImage)])
    {
        [self setShadowImage:nil];
    }
}

/** @brief 隐藏导航栏底部的黑线 */
- (void)hiddenNavigationBarLine
{
    
    [self setBackgroundImage:[UIImage new] doHideShadow:YES];
}

/** @brief 显示导航栏底部的黑线 */
- (void)showNavigationBarLine
{
    
    [self setBackgroundImage:[UIImage new] doHideShadow:NO];
}

/**
 *  @brief 根据颜色和颜色透明度设置背景图片
 *  @param color  颜色
 *  @param colorAlpha  颜色透明度
 */
- (void)setBackgroundImageWithColor:(UIColor *)color colorAlpha:(float)colorAlpha
{
    [self setBackgroundImage:[UIImage imageWithColor:[color colorWithAlphaComponent:colorAlpha] imageSize:CGSizeMake(1.f, 1.f)] forBarMetrics:UIBarMetricsDefault];
}

/**
 *  @brief 设置背景图片，是否隐藏阴影
 *  @param backgroundImage  背景图片
 *  @param doHideShadow  是否隐藏阴影
 */
- (void)setBackgroundImage:(UIImage *)backgroundImage doHideShadow:(BOOL)doHideShadow {
    static UIImage *shadowImage;
    
    if (backgroundImage){
        
        [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = shadowImage;
    } else {
        
        [self setBackgroundImageWithColor:self.barTintColor colorAlpha:1.f];
        self.shadowImage = shadowImage;
    }
    self.translucent = YES;
    if (doHideShadow) {
        shadowImage = self.shadowImage;
        self.shadowImage = [UIImage new];
    }
}

@end
