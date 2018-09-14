//
//  UIColor+LHTool.h
//  LHCategoryTool
//
//  Created by mo2323 on 2018/9/14.
//  Copyright © 2018年 mo2323. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LHTool)

/**
 *  @brief 获取16进制字符串颜色
 *  @params hexadecimalString  16进制颜色字符串，支持：@“#123456”、 @“0X123456”、 @“123456”三种格式
 */
+ (UIColor *)colorWith16HexadecimalString:(NSString *)hexadecimalString;

/**
 *  @brief 获取进制字符串颜色
 *  @params hexadecimalString  16进制颜色字符串，支持：@“#123456”、 @“0X123456”、 @“123456”三种格式
 *  @params alpha 颜色透明度
 */
+ (UIColor *)colorWith16HexadecimalString:(NSString *)hexadecimalString alpha:(CGFloat)alpha;



@end
