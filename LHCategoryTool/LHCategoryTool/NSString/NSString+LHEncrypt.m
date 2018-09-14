//
//  NSString+LHEncrypt.m
//  LHCategoryTool
//
//  Created by mo2323 on 2018/9/14.
//  Copyright © 2018年 mo2323. All rights reserved.
//

#import "NSString+LHEncrypt.h"
#import "NSData+LHEncrypt.h"
#import "NSString+LHTool.h"

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (LHEncrypt)

#pragma mark ==============Base64转码=============
/**
 *  Base64 加密基本原理：
 *  原本是 8个bit 一组表示数据,改为 6个bit一组表示数据,不足的部分补零,每个用 一个 = 表示
 *  用base64 编码之后,数据长度会变大,增加了大约 1/3 左右.(8-6)/6
 *  可进行反向解密，
 *  code7.0 之后出现的
 *  编码有个非常显著的特点,末尾有个 = 号
 *  ！！！！：切误用于数据加密或数据校验。
 Base64是一种数据编码方式，目的是让数据符合传输协议的要求。标准Base64编码解码无需额外信息即完全可逆，即使你自己自定义字符集设计一种类Base64的编码方式用于数据加密，在多数场景下也较容易破解
 */
- (NSString*)encodeBase64String {
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString * base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

/**
 *  Base64解密
 */
- (NSString *)decodeBase64String{
    
    NSData * baseData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString * base64String = [[NSString alloc] initWithData:baseData encoding:NSUTF8StringEncoding] ;
    return base64String;
}


- (NSString *)base64StringFromData:(NSData *)data length: (NSUInteger)length {
    // lentext data的长度
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    lentext = [data length];
    if (lentext < 1) {
        return @"";
    }
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) {
            break;
        }
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext) {
                input[i] = raw[ix];
            }
            else {
                input[i] = 0;
            }
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++) {
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        }
        
        for (i = ctcopy; i < 4; i++) {
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length)) {
            charsonline = 0;
        }
    }
    return result;
}

#pragma mark ===============MD5 密文==============
/**
 *  md2 加密
 */
- (NSString *)md2String
{
    NSData * data = [[self dataUsingEncoding:NSUTF8StringEncoding] MD2Sum];
    NSString * dataStr = [NSString stringWithFormat:@"%@",data];
    dataStr = [dataStr trimmingWithCharacter:@"<>"];
    dataStr = [dataStr trimmingAllWhitespace];
    return dataStr;
}

/**
 *  md4 加密
 */
- (NSString *)md4String;
{
    NSData * data = [[self dataUsingEncoding:NSUTF8StringEncoding] MD4Sum];
    NSString * dataStr = [NSString stringWithFormat:@"%@",data];
    dataStr = [dataStr trimmingWithCharacter:@"<>"];
    dataStr = [dataStr trimmingAllWhitespace];
    return dataStr;
}

/**
 *  md5 加密
 */
- (NSString *)md5String
{
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG)[self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

/**
 *  md5 加盐加密
 *
 */
- (NSString *)md5StringWithSalt:(NSString *)salt
{
    NSString * newStr = [[self md5String] stringByAppendingString:salt];
    return [newStr md5String];
}

/**
 *  32位 小写加密
 */
- (NSString *)md5ForLower32Bate {
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

/**
 *  md5 32位大写加密
 */
- (NSString *)md5ForUpper32Bate {
    
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

/**
 *  md5 16位大写加密
 */
- (NSString *)md5ForUpper16Bate {
    
    NSString *md5Str = [self md5ForUpper32Bate];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

/**
 *  md5 16位小写加密
 */
- (NSString *)MD5ForLower16Bate {
    
    NSString *md5Str = [self md5ForLower32Bate];
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

#pragma mark ===============SHA 密文==============
/**
 *  SHA1 加密
 */
- (NSString *)SHA1HashString;
{
    NSData * data = [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1Hash];
    NSString * dataStr = [NSString stringWithFormat:@"%@",data];
    dataStr = [dataStr trimmingWithCharacter:@"<>"];
    dataStr = [dataStr trimmingAllWhitespace];
    return dataStr;
}

/**
 *  SHA224 加密
 */
- (NSString *)SHA224HashString;
{
    NSData * data = [[self dataUsingEncoding:NSUTF8StringEncoding] SHA224Hash];
    NSString * dataStr = [NSString stringWithFormat:@"%@",data];
    dataStr = [dataStr trimmingWithCharacter:@"<>"];
    dataStr = [dataStr trimmingAllWhitespace];
    return dataStr;
}

/**
 *  SHA256 加密
 */
- (NSString *)SHA256HashString;
{
    NSData * data = [[self dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash];
    NSString * dataStr = [NSString stringWithFormat:@"%@",data];
    dataStr = [dataStr trimmingWithCharacter:@"<>"];
    dataStr = [dataStr trimmingAllWhitespace];
    return dataStr;
}

/**
 *  SHA384 加密
 */
- (NSString *)SHA384HashString;
{
    NSData * data = [[self dataUsingEncoding:NSUTF8StringEncoding] SHA384Hash];
    NSString * dataStr = [NSString stringWithFormat:@"%@",data];
    dataStr = [dataStr trimmingWithCharacter:@"<>"];
    dataStr = [dataStr trimmingAllWhitespace];
    return dataStr;
}

/**
 *  SHA512 加密
 */
- (NSString *)SHA512HashString;
{
    NSData * data = [[self dataUsingEncoding:NSUTF8StringEncoding] SHA512Hash];
    NSString * dataStr = [NSString stringWithFormat:@"%@",data];
    dataStr = [dataStr trimmingWithCharacter:@"<>"];
    dataStr = [dataStr trimmingAllWhitespace];
    return dataStr;
}

#pragma mark ===============AES 加密===============

/**
 *  AES + ECB 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)AESAndECBEncryptedStringUsingKey:(id)key {
    NSData *encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] AESAndECBEncryptedDataUsingKey:key ];
    NSString *base64EncodedString = [[NSString alloc] base64StringFromData:encryptedData length:encryptedData.length];
    return base64EncodedString;
}
/**
 *  AES + ECB 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)decryptedAESAndECBStringUsingKey:(id)key {
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptedData = [encryptedData decryptedAESAndECBDataUsingKey:key];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

/**
 *  AES + CBC 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)AESAndCBCEncryptedStringUsingKey:(id)key vector:(id)vi;
{
    NSData *encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] AESAndCBCEncryptedDataUsingKey:key vector:vi];
    NSString *base64EncodedString = [encryptedData base64EncodedStringWithOptions:0];
    return base64EncodedString;
}

/**
 *  AES + CBC 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)decryptedAESAndCBCStringUsingKey:(id)key vector:(id)vi;
{
    NSData * encryptedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptedData = [encryptedData decryptedAESAndCBCDataUsingKey:key vector:vi];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

#pragma mark ================DES=================
/**
 *  DES + ECB 模式加密 key 要大于64位／8字节否则和3DES一样
 */
- (NSString *)DESAndECBEncryptedStringUsingKey:(id)key;
{
    NSData * encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] DESAndECBEncryptedDataUsingKey:key];
    NSString * base64EncodedString = [encryptedData base64EncodedStringWithOptions:0];
    return base64EncodedString;
}
/**
 *  DES + ECB 模式解密
 */
- (NSString *)decryptedDESAndECBStringUsingKey:(id)key;
{
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptedData = [encryptedData decryptedDESAndECBDataUsingKey:key];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

/**
 *  DES + CBC 模式加密 key 要大于64位／8字节否则和3DES一样
 *  @param vi 密钥偏移量
 */
- (NSString *)DESAndCBCEncryptedDataUsingKey:(id)key vector:(id)vi;
{
    NSData * encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] DESAndCBCEncryptedDataUsingKey:key vector:vi];
    NSString * base64EncodedString = [encryptedData base64EncodedStringWithOptions:0];
    return base64EncodedString;
}
/**
 *  DES + CBC 模式解密
 *  @param vi 密钥偏移量
 */
- (NSString *)decryptedDESAndCBCDataUsingKey:(id)key vector:(id)vi;
{
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptedData = [encryptedData decryptedDESAndCBCDataUsingKey:key vector:vi];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

#pragma mark ================3DES================
/**
 *  3DES + ECB 模式加密
 */
- (NSString *)TripleDESAndECBEncryptedStringUsingKey:(id)key;
{
    NSData * encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] TripleDESAndECBEncryptedDataUsingKey:key];
    NSString * base64EncodedString = [encryptedData base64EncodedStringWithOptions:0];
    return base64EncodedString;
}
/**
 *  3DES + ECB 模式解密
 */
- (NSString *)decryptedTripleDESAndECBStringUsingKey:(id)key;
{
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptedData = [encryptedData decryptedTripleDESAndECBDataUsingKey:key];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

/**
 *  3DES + CBC 模式加密
 *  @param vi 密钥偏移量
 */
- (NSString *)TripleDESAndCBCEncryptedDataUsingKey:(id)key vector:(id)vi;
{
    NSData * encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] TripleDESAndCBCEncryptedDataUsingKey:key vector:vi];
    NSString * base64EncodedString = [encryptedData base64EncodedStringWithOptions:0];
    return base64EncodedString;
}
/**
 *  3DES + CBC 模式解密
 *  @param vi 密钥偏移量
 */
- (NSString *)decryptedTripleDESAndCBCDataUsingKey:(id)key vector:(id)vi;
{
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSData *decryptedData = [encryptedData decryptedTripleDESAndCBCDataUsingKey:key vector:vi];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}


@end
