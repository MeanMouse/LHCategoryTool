//
//  NSString+Tool.h
//  LHCategoryTool
//
//  Created by 梁辉 on 2017/12/26.
//  Copyright © 2017年 ElonZung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (LHTool)
#pragma mark - =======================判断格式=================================
/**
 *  判断字符串是否为空
 */
+ (BOOL)isNullOrEmpty:(NSString *)string;

/**
 *  判断是否是正确的手机号码格式
 */
- (BOOL)isMobileNumber;

/**
 *  判断身份证号码格式
 */

- (BOOL)isHxIdentityCard;

/**
 *  判断邮箱格式
 */
- (BOOL)isEmail;

/**
 *  判断是否为数字
 */
- (BOOL)isNumber;
/**
 *  判断url格式
 */
- (BOOL)isURL;

/**
 *  判断是不是九宫格键盘
 */
- (BOOL)isNineKeyBoard;

/**
 *  判断字符串中是否存在emoji
 */
- (BOOL)hasEmoji;

/**
 *  判断字符串中是否存在emoji
 */
- (BOOL)stringContainsEmoji;

#pragma mark -====== 字符串操作 ======
/**
 *  剔除字符串2端的空格
 */
- (NSString *)trimming;

/**
 *  剔除字符串所有的空格
 */
- (NSString *)trimmingAllWhitespace;

/**
 *  剔除字符串的字符
 */
- (NSString *)trimmingWithCharacter:(NSString *)character;

/**
 *  剔除字符串的字符
 */
- (NSString *)substringFromString:(NSString *)string;

/**
 *  字符串转json字符串
 */
- (NSString *)jsonStringWithString:(NSString *)string;

/**
 *  数组转json字符串
 */
- (NSString *) jsonStringWithArray:(NSArray *)array;

/**
 *  字典转json字符串
 */
- (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

- (NSString *)jsonStringWithObject:(id)object;

/**
 *  根据宽度计算字符串文本的高度
 */
- (CGFloat)textHeightWithWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)spacing;

- (CGFloat)getLabelTextHeightWithWidth:(CGFloat)width font:(UIFont *)font;
/**
 *  获取单行文本长度
 */
- (CGFloat)getWidthForTextWithFont:(UIFont *)font;

/**
 *  获取单行文本的Rect
 */
- (CGRect)getRectForTextWithFont:(UIFont *)font;

/**
 *  获取URL字符串中指定参数的值
 */
- (NSString *)valueWithURLParamName:(NSString *)paramName;

#pragma mark -========================文件路径=================================
/**
 *  获取Home目录路径
 */
+ (NSString *)pathForHomeDirectory;

/**
 *  获取Documents目录路径
 */
+ (NSString *)pathForDocuments;

/**
 *  获取Caches目录路径
 */
+ (NSString *)pathForCaches;

/**
 *  获取Tmp目录路径
 */
+ (NSString *)pathForTmp;

/**
 *  根据文件名、文件格式获取文件路径
 */
+ (NSString *)pathWithFileName:(NSString *)fileName type:(NSString *)type;

#pragma mark - ======================加密=======================

@end
