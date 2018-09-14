//
//  UIColor+LHTool.m
//  LHCategoryTool
//
//  Created by mo2323 on 2018/9/14.
//  Copyright © 2018年 mo2323. All rights reserved.
//

#import "UIColor+LHTool.h"

@implementation UIColor (LHTool)

/**
 *  @brief 获取16进制字符串颜色
 *  @params hexadecimalString  16进制颜色字符串，支持：@“#123456”、 @“0X123456”、 @“123456”三种格式
 */
+ (UIColor *)colorWith16HexadecimalString:(NSString *)hexadecimalString
{
    return [self colorWith16HexadecimalString:hexadecimalString alpha:1.0];
}

/**
 *  @brief 获取进制字符串颜色
 *  @params hexadecimalString  16进制颜色字符串，支持：@“#123456”、 @“0X123456”、 @“123456”三种格式
 *  @params alpha 颜色透明度
 */
+ (UIColor *)colorWith16HexadecimalString:(NSString *)hexadecimalString alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *colorString = [[hexadecimalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([colorString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([colorString hasPrefix:@"0X"])
    {
        colorString = [colorString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorString hasPrefix:@"#"])
    {
        colorString = [colorString substringFromIndex:1];
    }
    if ([colorString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [colorString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [colorString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [colorString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


@end
