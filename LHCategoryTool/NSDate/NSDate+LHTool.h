//
//  NSDate+Tool.h
//  LHCategoryTool
//
//  Created by 梁辉 on 2017/12/22.
//  Copyright © 2017年 梁辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LHTool)

#pragma mark - 获取日期信息
/**
 *  日期的 年
 */
- (NSInteger)year;

/**
 *  日期的 月
 */
- (NSInteger)month;

/**
 *  日期的 日
 */
- (NSInteger)day;

/**
 *  日期的 时
 */
- (NSInteger)hour;

/**
 *  日期的 分
 */
- (NSInteger)minute;
/**
 *  日期的 秒
 */
- (NSInteger)second;

/**
 *  日期的 星期
 */
- (NSInteger )weekDayIndex;
- (NSString *)weekDay;

/**
 *  日期当月的第一天是周几
 */
- (NSString *)firstWeekDayInMonth;

/**
 *  该星期的开始日期（星期日）
 */
- (NSDate *)weekStart;
/**
 *  该星期的结束日期（星期六）
 */
- (NSDate *)weekEnd;

/**
 *  获取该星期各天数的日期
 */
- (NSDate *)dateWithWeekDay:(NSInteger)weekDay;
/**
 *  一个月有多少天
 */
- (NSInteger)numDaysInMonth;

/**
 *  获取从日期到后六天，共计七天的日期字典信息，
 */
- (NSArray *)sevenDateInfoArray;

/**
 *  获取日期的信息，返回字典key：week、month-day、year-month-day
 */
- (NSDictionary *)dateDictInfo;

/**
 *  日期转日期字符串
 */
- (NSString *)dateString;
/**
 *  日期字符串转日期
 */
- (NSDate *)dateString:(NSString *)dateString;

/**
 *  获取一个标准时间戳与当前时间的时间差文本显示
 */
- (NSString *)standardTimeIntervalText;

#pragma mark - 时间偏移方法（时间的加减）

/**
 *  年份的加减
 */
- (NSDate *)setOffSetYear:(NSInteger)year;

/**
 *  月份的加减
 */
- (NSDate *)setOffSetMonth:(NSInteger)month;

/**
 *  天数的加减
 */
- (NSDate *)setOffSetDay:(NSInteger)day;

/**
 *  时数的加减
 */
- (NSDate *)setOffSetHours:(NSInteger)hour;

/**
 *  分数的加减
 */
- (NSDate *)setOffSetMinutes:(NSInteger)minute;

/**
 *  秒数的加减
 */
- (NSDate *)setOffSetSeconds:(NSInteger)second;

@end
