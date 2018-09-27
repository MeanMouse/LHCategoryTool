//
//  NSDate+Tool.m
//  LHCategoryTool
//
//  Created by 梁辉 on 2017/12/22.
//  Copyright © 2017年 梁辉. All rights reserved.
//

#import "NSDate+LHTool.h"

@implementation NSDate (LHTool)

#pragma mark - 获取日期信息
/**
 *  日期的 年
 */
- (NSInteger)year {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

/**
 *  日期的 月
 */
- (NSInteger)month {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

/**
 *  日期的 日
 */
- (NSInteger)day {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

/**
 *  日期的 时
 */
- (NSInteger)hour {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

/**
 *  日期的 分
 */
- (NSInteger)minute {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

/**
 *  日期的 秒
 */
- (NSInteger)second {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}

/**
 *  日期的 星期
 */
- (NSInteger )weekDayIndex {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday] - 1;
}

- (NSString *)weekDay {
    NSArray * weekDayNames = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    NSInteger index = [self weekDayIndex];
    return weekDayNames[index];
}

/**
 *  日期当月的第一天是周几
 */
- (NSString *)firstWeekDayInMonth{
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:self];
    [comps setDay:1];
    NSDate * newDate = [calendar dateFromComponents:comps];
    return [newDate weekDay];
}

/**
 *  该星期的开始日期（星期日）
 */
- (NSDate *)weekStart{
    return [self dateWithWeekDay:0];
}

/**
 *  该星期的结束日期（星期六）
 */
- (NSDate *)weekEnd {
    return [self dateWithWeekDay:6];
}

/**
 *  获取该星期各天数的日期
 */
- (NSDate *)dateWithWeekDay:(NSInteger)weekDay {
    NSInteger nowWeekDay = [self weekDayIndex];
    NSInteger offset = weekDay - nowWeekDay;
    if (offset == 0) {
        return self;
    } else {
        return [self setOffSetDay:offset];
    }
}

/**
 *  一个月有多少天
 */
- (NSInteger)numDaysInMonth {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numDays = range.length;
    return numDays;
}

/**
 *  获取从日期到后六天，共计七天的日期字典信息，
 */
- (NSArray *)sevenDateInfoArray
{
    NSDate * date2 = [self setOffSetDay:1];
    NSDate * date3 = [self setOffSetDay:2];
    NSDate * date4 = [self setOffSetDay:3];
    NSDate * date5 = [self setOffSetDay:4];
    NSDate * date6 = [self setOffSetDay:5];
    NSDate * date7 = [self setOffSetDay:6];
    return [NSArray arrayWithObjects:[self dateDictInfo],[date2 dateDictInfo],[date3 dateDictInfo],[date4 dateDictInfo],[date5 dateDictInfo],[date6 dateDictInfo],[date7 dateDictInfo], nil];
}

/**
 *  获取日期的信息，返回字典key：week、month-day、year-month-day
 */
- (NSDictionary *)dateDictInfo {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSString * monthDay = [NSString stringWithFormat:@"%ld月%ld日",[self month],[self day]];
    NSString * weekName = [self weekDay];
    NSString * yearMothDay = [NSString stringWithFormat:@"%ld年%ld月%ld日",[self year],[self month],[self day]];
    [dict setValue:weekName forKey:@"week"];
    [dict setValue:monthDay forKey:@"month-day"];
    [dict setValue:yearMothDay forKey:@"year-month-day"];
    return dict;
}

/**
 *  日期转日期字符串
 */
- (NSString *)dateString{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:self];
}

/**
 *  日期字符串转日期
 */
- (NSDate *)dateString:(NSString *)dateString {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

/**
 *  获取一个标准时间戳与当前时间的时间差文本显示
 */
- (NSString *)standardTimeIntervalText{
    //进行时间差比较(秒为单位)
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self];
    //计算出天、小时、分钟
    NSMutableString * timeStr = [[NSMutableString alloc]init];
    NSInteger minite = timeInterval / 60;
    if (minite < 1) {
        [timeStr appendString:[NSString stringWithFormat:@"刚刚"]];
    } else if (minite >= 1 && minite < 60) {
        [timeStr appendString:[NSString stringWithFormat:@"%ld分钟前",minite]];
    } else if (minite >= 60 && minite < (60 * 24)) {
        NSInteger hour = minite / 60;
        [timeStr appendString:[NSString stringWithFormat:@"%ld小时前",hour]];
    } else if (minite >= (60 * 24) && minite < (60 * 24) * 30) {
        NSInteger day = minite / (60 * 24);
        [timeStr appendString:[NSString stringWithFormat:@"%ld天前",day]];
    } else if (minite >= (60 * 24) * 30 && minite < (60 * 24) * 30 * 12) {
        NSInteger month = minite / ((60 * 24) * 30);
        [timeStr appendString:[NSString stringWithFormat:@"%ld月前",month]];
    } else if (minite > (60 * 24) * 30 * 12 && minite < (60 * 24) * 30 * 12 * 3) {
        NSInteger year = minite / ((60 * 24) * 30 * 12);
        [timeStr appendString:[NSString stringWithFormat:@"%ld年前",year]];
    } else {
        [timeStr appendString:[self dateString]];
    }
    
    return  timeStr;
}

#pragma mark - 时间偏移方法（时间的加减）

/**
 *  年份的加减
 */
- (NSDate *)setOffSetYear:(NSInteger)year {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:year];
    return [calendar dateByAddingComponents:offsetComponents
                                          toDate:self options:0];
}

/**
 *  月份的加减
 */
- (NSDate *)setOffSetMonth:(NSInteger)month {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:month];
    return [calendar dateByAddingComponents:offsetComponents
                                          toDate:self options:0];
}

/**
 *  天数的加减
 */
- (NSDate *)setOffSetDay:(NSInteger)day {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:day];
    return [calendar dateByAddingComponents:offsetComponents
                                          toDate:self options:0];
}

/**
 *  时数的加减
 */
- (NSDate *)setOffSetHours:(NSInteger)hour {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:hour];
    return [calendar dateByAddingComponents:offsetComponents
                                          toDate:self options:0];
}

/**
 *  分数的加减
 */
- (NSDate *)setOffSetMinutes:(NSInteger)minute {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMinute:minute];
    return [calendar dateByAddingComponents:offsetComponents
                                          toDate:self options:0];
}

/**
 *  秒数的加减
 */
- (NSDate *)setOffSetSeconds:(NSInteger)second {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setSecond:second];
    return [calendar dateByAddingComponents:offsetComponents
                                          toDate:self options:0];
}

@end
