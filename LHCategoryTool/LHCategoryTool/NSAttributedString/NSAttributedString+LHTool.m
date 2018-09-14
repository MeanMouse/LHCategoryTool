//
//  NSAttributedString+Tool.m
//  YykqClinet
//
//  Created by 梁辉 on 2018/4/16.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import "NSAttributedString+LHTool.h"
#import "NSString+LHTool.h"

@implementation NSAttributedString (LHTool)

+ (NSAttributedString *)string:(NSString *)string changeSubString:(NSString *)subString withColor:(UIColor *)color
{
    if ([NSString isNullOrEmpty:string] || [NSString isNullOrEmpty:subString]) {
        return nil;
    }
    NSRange subStringRange = [string rangeOfString:subString];
    if (subStringRange.location != NSNotFound) {
        NSMutableAttributedString *multAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [multAttributedString addAttribute:NSForegroundColorAttributeName value:color range:subStringRange];
        return [multAttributedString mutableCopy];
    } else {
        NSMutableAttributedString *multAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [multAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, multAttributedString.length)];
        return [multAttributedString mutableCopy];
    }
}

@end
