//
//  NSString+LHEncrypt.h
//  LHCategoryTool
//
//  Created by 梁辉 on 2018/4/16.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LHEncrypt)

#pragma mark ==============Base64转码==============
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
- (NSString*)encodeBase64String;
/**
 *  Base64解密
 */
- (NSString *)decodeBase64String;

- (NSString *)base64StringFromData:(NSData *)data length: (NSUInteger)length;

#pragma mark ===============MD5 密文==============
/**
 *  md2 加密
 */
- (NSString *)md2String;

/**
 *  md4 加密
 */
- (NSString *)md4String;

/**
 *  md5 加密
 */
- (NSString *)md5String;

/**
 *  md5 加盐加密
 */
- (NSString *)md5StringWithSalt:(NSString *)salt;

/**
 *  32位 小写加密
 */
- (NSString *)md5ForLower32Bate;

/**
 *  md5 32位大写加密
 */
- (NSString *)md5ForUpper32Bate;
/**
 *  md5 16位大写加密
 */
- (NSString *)md5ForUpper16Bate;

/**
 *  md5 16位小写加密
 */
- (NSString *)MD5ForLower16Bate;

#pragma mark ===============SHA 密文==============
/**
 *  SHA1 加密
 */
- (NSString *)SHA1HashString;
/**
 *  SHA224 加密
 */
- (NSString *)SHA224HashString;
/**
 *  SHA256 加密
 */
- (NSString *)SHA256HashString;
/**
 *  SHA384 加密
 */
- (NSString *)SHA384HashString;
/**
 *  SHA512 加密
 */
- (NSString *)SHA512HashString;

#pragma mark ===============AES 加密===============
/**
 *  AES + ECB 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)AESAndECBEncryptedStringUsingKey:(id)key;
/**
 *  AES + ECB 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)decryptedAESAndECBStringUsingKey:(id)key;
/**
 *  AES + CBC 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)AESAndCBCEncryptedStringUsingKey:(id)key vector:(id)iv;
/**
 *  AES + CBC 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSString *)decryptedAESAndCBCStringUsingKey:(id)key vector:(id)iv;

#pragma mark ================DES=================
/**
 *  DES + ECB 模式加密 key 要大于64位／8字节否则和3DES一样
 */
- (NSString *)DESAndECBEncryptedStringUsingKey:(id)key;
/**
 *  DES + ECB 模式解密
 */
- (NSString *)decryptedDESAndECBStringUsingKey:(id)key;

/**
 *  DES + CBC 模式加密 key 要大于64位／8字节否则和3DES一样
 *  @param iv 密钥偏移量
 */
- (NSString *)DESAndCBCEncryptedDataUsingKey:(id)key vector:(id)iv;
/**
 *  DES + CBC 模式解密
 *  @param iv 密钥偏移量
 */
- (NSString *)decryptedDESAndCBCDataUsingKey:(id)key vector:(id)iv;

#pragma mark ================3DES================
/**
 *  3DES + ECB 模式加密
 */
- (NSString *)TripleDESAndECBEncryptedStringUsingKey:(id)key;
/**
 *  3DES + ECB 模式解密
 */
- (NSString *)decryptedTripleDESAndECBStringUsingKey:(id)key;

/**
 *  3DES + CBC 模式加密
 *  @param iv 密钥偏移量
 */
- (NSString *)TripleDESAndCBCEncryptedDataUsingKey:(id)key vector:(id)iv;
/**
 *  3DES + CBC 模式解密
 *  @param iv 密钥偏移量
 */
- (NSString *)decryptedTripleDESAndCBCDataUsingKey:(id)key vector:(id)iv;


@end
