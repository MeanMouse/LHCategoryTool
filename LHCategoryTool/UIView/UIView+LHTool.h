//
//  UIView+LHTool.h
//  LHCategoryTool
//
//  Created by mo2323 on 2018/9/14.
//  Copyright © 2018年 mo2323. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LHTool)

/** @brief 切圆 */
- (void)corner;

/**
 *  @brief 切圆，是否裁剪子视图
 *  @param clipsToBounds  是否裁剪子视图
 */
- (void)cornerRadius:(CGFloat)radius clipsToBounds:(BOOL)clipsToBounds;

/**
 *  @brief 边框
 *  @param borderWidth  边框宽度
 *  @param borderColor  边框颜色
 */
- (void)borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
