//
//  NSAttributedString+Tool.h
//  YykqClinet
//
//  Created by 梁辉 on 2018/4/16.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (LHTool)
+ (NSAttributedString *)string:(NSString *)string changeSubString:(NSString *)subString withColor:(UIColor *)color;

@end
