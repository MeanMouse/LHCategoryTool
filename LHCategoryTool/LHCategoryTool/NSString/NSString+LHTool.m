//
//  NSString+Tool.m
//  YykqClinet
//
//  Created by 梁辉 on 2017/12/26.
//  Copyright © 2017年 ElonZung. All rights reserved.
//

#import "NSString+LHTool.h"

@implementation NSString (LHTool)

#pragma mark - =========================判断格式=========================
/**
 *  判断字符串是否为空
 */
+ (BOOL)isNullOrEmpty:(NSString *)string
{
    if (string) {
        if ([string isKindOfClass: [NSNull class]]) {
            
            return YES;
        } else {
            if (string.length == 0) {
                
                return YES;
            } else {
                
                return NO;
            }
        }
    }
        return YES;
}

/**
 *  判断是否是正确的手机号码格式
 */
- (BOOL)isMobileNumber{
    //手机号码13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    
    //中国移动：China Mobile
    //移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
    NSString * CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    
    //中国联通：China Mobile
    //联通号段: 130,131,132,152,155,156,185,186
    NSString * CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    //中国电信：China Telecom
    //电信号段: 133,1349,153,180,189
    NSString * CT = @"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[8,9]))\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 ){
        return YES;
    }else{
        return NO;
    }
}

/**
 *  判断身份证号码格式
 */

-(BOOL)isHxIdentityCard
{
    // 判断位数
    if ([self length] != 15 && [self length] != 18)
    {
        return NO;
    }
    
    NSString *carid = self;
    long lSumQT  =0;
    // 加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    // 校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    // 将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:self];
    if ([self length] == 15)
    {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    // 判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince])
    {
        return NO;
    }
    // 判断年月日是否有效
    // 年份
    int strYear = [[carid substringWithRange:NSMakeRange(6,4)] intValue];
    // 月份
    int strMonth = [[carid substringWithRange:NSMakeRange(10,2)] intValue];
    // 日
    int strDay = [[carid substringWithRange:NSMakeRange(12,2)] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil)
    {
        return NO;
    }
    const char *PaperId  = [carid UTF8String];
    // 检验长度
    if( 18 != strlen(PaperId)) return -1;
    // 校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    // 验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    return YES;
}

-(BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

/**
 *  判断邮箱格式
 */
- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 *  判断是否为数字
 */
- (BOOL)isNumber {
    NSString *numberRegex = @"\\-?\\d+";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:self];
}

/**
 *  判断url格式
 */
- (BOOL)isURL {
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\\\u4e00-\\u9fa5]*)+)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:self];
}

/**
 *  判断是不是九宫格
 */
- (BOOL)isNineKeyBoard
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)self.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:self].location != NSNotFound))
            return NO;
    }
    return YES;
}

/**
 *  判断字符串中是否存在emoji
 */
- (BOOL)hasEmoji
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

/**
 *  判断字符串中是否存在emoji
 */
- (BOOL)stringContainsEmoji {
    
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

#pragma mark - ========================字符串操作=========================
/**
 *  剔除字符串2端的空格
 */
- (NSString *)trimming{
    //whitespaceCharacterSet  剔除2端的空格
    //whitespaceAndNewlineCharacterSet 剔除空格和回车符
    //创建自己想剔除特殊字符 NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    // 更多字符集-》用按command点击下方whitespaceCharacterSet，我什么都不知道
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 *  剔除字符串所有的空格
 */
- (NSString *)trimmingAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 *  剔除字符串的字符
 */
- (NSString *)trimmingWithCharacter:(NSString *)character{
   NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:character];
    return [self stringByTrimmingCharactersInSet:set];
}

/**
 *  剔除字符串的字符
 */
- (NSString *)substringFromString:(NSString *)string;
{
    if ([NSString isNullOrEmpty:string]) {
        return self;
    }
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        
        return [self substringFromIndex:range.location];
    } else {
        
        return self;
    }
}

/**
 *  根据替换字符串数组，替换为string字符
 */
- (NSString *)stringByReplacingOccurrencesOfStrings:(NSArray *)strings withString:(NSString *)string
{
    if (!string) return self;
    NSString *replaceString = [self copy];
    for (NSString *subString in strings) {
        replaceString = [replaceString stringByReplacingOccurrencesOfString:subString withString:string];
    }
    return replaceString;
}

/**
 *  根据替换字符字典，替换字符串中相对应字符（key：@“被替换字符”，value：@“替换字符”）
 */
- (NSString *)stringByReplacingOccurrencesOfStringReplaceDict:(NSDictionary *)replaceDict
{
    if (!replaceDict) return self;
    NSString *replaceString = [self copy];
    for (NSString *key in replaceDict.allKeys) {
        replaceString = [replaceString stringByReplacingOccurrencesOfString:key withString:replaceDict[key]];
    }
    return replaceString;
}

/**
 *  字符串转json字符串
 */
- (NSString *)jsonStringWithString:(NSString *)string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

/**
 *  数组转json字符串
 */
- (NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

/**
 *  字典转json字符串
 */
- (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

- (NSString *)jsonStringWithObject:(id)object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}

/**
 *  根据宽度计算字符串文本的高度
 */
- (CGFloat)textHeightWithWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)spacing;
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = spacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    label.font = font;
    label.numberOfLines = 0;
    label.attributedText = attributeString;
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

- (CGFloat)getLabelTextHeightWithWidth:(CGFloat)width font:(UIFont *)font
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.font = font;
    label.numberOfLines = 0;
    label.text = self;
    [label sizeToFit];
    return label.bounds.size.height;
}

/**
 *  获取单行文本长度
 */
- (CGFloat)getWidthForTextWithFont:(UIFont *)font
{
   return [self getRectForTextWithFont:font].size.width;
}

/**
 *  获取单行文本的Rect
 */
- (CGRect)getRectForTextWithFont:(UIFont *)font
{
    UILabel * label = [[UILabel alloc] init];
    label.font = font;
    label.text = self;
    [label sizeToFit];
    return label.bounds;
}

/**
 *  获取URL字符串中指定参数的值
 */
- (NSString *)valueWithURLParamName:(NSString *)paramName
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",paramName];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [self substringWithRange:[match rangeAtIndex:2]];
        return tagValue;
    }
    return nil;
}

#pragma mark -========================文件路径=================================
/**
 *  获取Home目录路径
 */
+ (NSString *)pathForHomeDirectory;
{
    return NSHomeDirectory();
}

/**
 *  获取Documents目录路径
 */
+ (NSString *)pathForDocuments;
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  获取Caches目录路径
 */
+ (NSString *)pathForCaches;
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  获取Tmp目录路径
 */
+ (NSString *)pathForTmp;
{
    return NSTemporaryDirectory();
}

/**
 *  根据文件名、文件格式获取文件路径
 */
+ (NSString *)pathWithFileName:(NSString *)fileName type:(NSString *)type;
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:type];
}


@end
