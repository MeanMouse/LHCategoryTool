//
//  NSData+LHEncrypt.h
//  LHCategoryTool
//
//  Created by 梁辉 on 2017/12/27.
//  Copyright © 2017年 梁辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSData (LHEncrypt)
#pragma mark - ==============线性散列算法=============
/**
 *  线性散列算法（签名算法)
 *  这几种算法只生成一串不可逆的密文，经常用其效验数据传输过程中是否经过修改，因为相同的生成算法对于同一明文只会生成唯一的密文，若相同算法生成的密文不同，则证明传输数据进行过了修改。
 */
#pragma mark  ==============MD===============
- (NSData *)MD2Sum;
- (NSData *)MD4Sum;
- (NSData *)MD5Sum;

#pragma mark  ==============SHA==============
- (NSData *)SHA1Hash;
- (NSData *)SHA224Hash;
- (NSData *)SHA256Hash;
- (NSData *)SHA384Hash;
- (NSData *)SHA512Hash;

#pragma mark  ==============HMAC=============
/**
 *  @brief  根据HMAC算法生成相对应的密文
 *  @param  alg     密文生成算法：kCCHmacAlgSHA1,kCCHmacAlgMD5,kCCHmacAlgSHA256,kCCHmacAlgSHA384,kCCHmacAlgSHA512,kCCHmacAlgSHA224
 *  @return result  操作后加密的数据
 */
- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)alg;
/**
 *  @brief  根据HMAC算法和key生成相对应的密文
 *  @param  alg     密文生成算法：kCCHmacAlgSHA1,kCCHmacAlgMD5,kCCHmacAlgSHA256,kCCHmacAlgSHA384,kCCHmacAlgSHA512,kCCHmacAlgSHA224
 *  @return result  操作后加密的数据
 */
- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)alg key:(id)key;

#pragma mark - ==============对称性加密算法=============

#pragma mark ===============AES===============
/**
 *  AES + ECB 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)AESAndECBEncryptedDataUsingKey:(id)key;
/**
 *  AES + ECB 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)decryptedAESAndECBDataUsingKey:(id)key;

/**
 *  AES + CBC 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)AESAndCBCEncryptedDataUsingKey:(id)key vector:(id)iv;
/**
 *  AES + CBC 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)decryptedAESAndCBCDataUsingKey:(id)key vector:(id)iv;

#pragma mark ===============DES===============
/**
 *  DES + ECB 模式加密 key 要大于64位／8字节否则和3DES一样
 */
- (NSData *)DESAndECBEncryptedDataUsingKey:(id)key;
/**
 *  DES + ECB 模式解密
 */
- (NSData *)decryptedDESAndECBDataUsingKey:(id)key;

/**
 *  DES + CBC 模式加密 key 要大于64位／8字节否则和3DES一样
 *  @param iv 密钥偏移量
 */
- (NSData *)DESAndCBCEncryptedDataUsingKey:(id)key vector:(id)iv;
/**
 *  DES + CBC 模式解密
 *  @param iv 密钥偏移量
 */
- (NSData *)decryptedDESAndCBCDataUsingKey:(id)key vector:(id)iv;


#pragma mark ==============3DES===============
/**
 *  3DES + ECB 模式加密
 */
- (NSData *)TripleDESAndECBEncryptedDataUsingKey:(id)key;
/**
 *  3DES + ECB 模式解密
 */
- (NSData *)decryptedTripleDESAndECBDataUsingKey:(id)key;

/**
 *  3DES + CBC 模式加密
 *  @param iv 密钥偏移量
 */
- (NSData *)TripleDESAndCBCEncryptedDataUsingKey:(id)key vector:(id)iv;
/**
 *  3DES + CBC 模式解密
 *  @param iv 密钥偏移量
 */
- (NSData *)decryptedTripleDESAndCBCDataUsingKey:(id)key vector:(id)iv;

#pragma mark ===============CAS===============
- (NSData *)CASTEncryptedDataUsingKey:(id)key;
- (NSData *)decryptedCASTDataUsingKey:(id)key;

@end
