//
//  NSData+Tool.m
//  NSString和NSMutableString
//
//  Created by 梁辉 on 2017/12/27.
//  Copyright © 2017年 梁辉. All rights reserved.
//

#import "NSData+LHEncrypt.h"


/**
 * @brief 对keyData的长度进行扩充或截断
 * 设置的长度大小大于当前大小，会在当前数据的末尾处用归零字节来进行填充。
 * 设置的长度大小小于当前大小，数据会被截断抛弃。
 */
static void FixKeyLengths( CCAlgorithm algorithm, NSMutableData * keyData, NSMutableData * ivData )
{
    NSUInteger keyLength = [keyData length];
    switch ( algorithm )
    {
        case kCCAlgorithmAES128:
        {
            if ( keyLength < 16 )
            {
                [keyData setLength: 16];
            }
            else if ( keyLength < 24 )
            {
                [keyData setLength: 24];
            }
            else
            {
                [keyData setLength: 32];
            }
            
            break;
        }
            
        case kCCAlgorithmDES:
        {
            [keyData setLength: 8];
            break;
        }
            
        case kCCAlgorithm3DES:
        {
            [keyData setLength: 24];
            break;
        }
            
        case kCCAlgorithmCAST:
        {
            if ( keyLength < 5 )
            {
                [keyData setLength: 5];
            }
            else if ( keyLength > 16 )
            {
                [keyData setLength: 16];
            }
            
            break;
        }
            
        case kCCAlgorithmRC4:
        {
            if ( keyLength > 512 )
                [keyData setLength: 512];
            break;
        }
            
        default:
            break;
    }
    
    [ivData setLength: [keyData length]];
}


@implementation NSData (Tool)

#pragma mark - ==============线性散列算法=============
/**
 *  线性散列算法（签名算法)
 *  这几种算法只生成一串不可逆的密文，经常用其效验数据传输过程中是否经过修改，因为相同的生成算法对于同一明文只会生成唯一的密文，若相同算法生成的密文不同，则证明传输数据进行过了修改。
 */


#pragma mark  ==============MD===============
- (NSData *)MD2Sum
{
    unsigned char hash[CC_MD2_DIGEST_LENGTH];
    (void) CC_MD2( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD2_DIGEST_LENGTH] );
}

- (NSData *)MD4Sum
{
    unsigned char hash[CC_MD4_DIGEST_LENGTH];
    (void) CC_MD4( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD4_DIGEST_LENGTH] );
}

- (NSData *)MD5Sum
{
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    (void) CC_MD5( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD5_DIGEST_LENGTH] );
}

#pragma mark  ==============SHA==============

- (NSData *)SHA1Hash
{
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void) CC_SHA1( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA1_DIGEST_LENGTH] );
}

- (NSData *)SHA224Hash
{
    unsigned char hash[CC_SHA224_DIGEST_LENGTH];
    (void) CC_SHA224( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA224_DIGEST_LENGTH] );
}

- (NSData *)SHA256Hash
{
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}

- (NSData *)SHA384Hash
{
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    (void) CC_SHA384( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA384_DIGEST_LENGTH] );
}

- (NSData *)SHA512Hash
{
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void) CC_SHA512( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}

#pragma mark  ==============HMAC=============
/**
 *  @brief  根据HMAC算法生成相对应的密文
 *  @param  alg     密文生成算法：kCCHmacAlgSHA1,kCCHmacAlgMD5,kCCHmacAlgSHA256,kCCHmacAlgSHA384,kCCHmacAlgSHA512,kCCHmacAlgSHA224
 *  @return result  操作后加密的数据
 */
- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)alg
{
    return ( [self HMACWithAlgorithm:alg key: nil] );
}

/**
 *  @brief  根据HMAC算法和key生成相对应的密文
 *  @param  alg     密文生成算法：kCCHmacAlgSHA1,kCCHmacAlgMD5,kCCHmacAlgSHA256,kCCHmacAlgSHA384,kCCHmacAlgSHA512,kCCHmacAlgSHA224
 *  @return result  操作后加密的数据
 */
- (NSData *)HMACWithAlgorithm:(CCHmacAlgorithm)alg key:(id) key
{
    NSParameterAssert(key == nil || [key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    
    NSData * keyData = nil;
    if ( [key isKindOfClass: [NSString class]] )
        keyData = [key dataUsingEncoding: NSUTF8StringEncoding];
    else
        keyData = (NSData *) key;
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(alg, [keyData bytes], [keyData length], [self bytes], [self length], buf );
    return ( [NSData dataWithBytes: buf length: (alg == kCCHmacAlgMD5 ? CC_MD5_DIGEST_LENGTH : CC_SHA1_DIGEST_LENGTH)] );
}

#pragma mark - ==============对称性加密算法=============

#pragma mark ===============AES===============
/**
 *  AES + ECB 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)AESAndECBEncryptedDataUsingKey:(id)key
{
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmAES
                                                    key: key
                                                options: kCCOptionPKCS7Padding | kCCOptionECBMode];
    return ( result );
}
/**
 *  AES + ECB 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)decryptedAESAndECBDataUsingKey:(id)key
{
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmAES
                                                    key: key
                                                options: kCCOptionPKCS7Padding | kCCOptionECBMode];
    
    return ( result );
}

/**
 *  AES + CBC 加密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)AESAndCBCEncryptedDataUsingKey:(id)key vector:(id)iv
{
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmAES
                                                    key: key
                                   initializationVector: iv
                                                options: kCCOptionPKCS7Padding];
    return ( result );
}
/**
 *  AES + CBC 解密 128位、192位、256密钥分别为16字节、24字节、32字节
 */
- (NSData *)decryptedAESAndCBCDataUsingKey:(id)key vector:(id)iv
{
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmAES
                                                    key: key
                                   initializationVector: iv
                                                options: kCCOptionPKCS7Padding];
    
    return ( result );
}

#pragma mark ===============DES===============
/**
 *  DES + ECB 模式加密 key 要大于64位／8字节否则和3DES一样
 */
- (NSData *)DESAndECBEncryptedDataUsingKey:(id)key
{
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmDES
                                                    key: key
                                                options: kCCOptionPKCS7Padding | kCCOptionECBMode];
    
    return ( result );
}

/**
 *  DES + ECB 模式解密
 */
- (NSData *)decryptedDESAndECBDataUsingKey:(id)key
{
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmDES
                                                    key: key
                                                options: kCCOptionPKCS7Padding | kCCOptionECBMode];
    return ( result );
}

/**
 *  DES + CBC 模式加密 key 要大于64位／8字节否则和3DES一样
 *  @param vi 密钥偏移量
 */
- (NSData *)DESAndCBCEncryptedDataUsingKey:(id)key vector:(id)vi;
{
    NSData * result = [self dataEncryptedUsingAlgorithm:kCCAlgorithmDES key:key initializationVector:vi options:kCCOptionPKCS7Padding];
    return ( result );
}

/**
 *  DES + CBC 模式解密
 *  @param vi 密钥偏移量
 */
- (NSData *)decryptedDESAndCBCDataUsingKey:(id)key vector:(id)vi;
{
    NSData * result = [self decryptedDataUsingAlgorithm:kCCAlgorithmDES key:key initializationVector:vi options:kCCOptionPKCS7Padding];
    return ( result );
}

#pragma mark ==============3DES===============
/**
 *  3DES + ECB 模式加密
 */
- (NSData *)TripleDESAndECBEncryptedDataUsingKey:(id)key
{
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithm3DES
                                                    key: key
                                                options: kCCOptionPKCS7Padding | kCCOptionECBMode];
    
    return ( result );
}

/**
 *  3DES + ECB 模式解密
 */
- (NSData *)decryptedTripleDESAndECBDataUsingKey:(id)key
{
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithm3DES
                                                    key: key
                                                options: kCCOptionPKCS7Padding | kCCOptionECBMode];
    return ( result );
}

/**
 *  3DES + CBC 模式加密
 *  @param iv 密钥偏移量
 */
- (NSData *)TripleDESAndCBCEncryptedDataUsingKey:(id)key vector:(id)iv;
{
    NSData * result = [self dataEncryptedUsingAlgorithm:kCCAlgorithm3DES key:key initializationVector:iv options:kCCOptionPKCS7Padding];
    return ( result );
}

/**
 *  3DES + CBC 模式解密
 *  @param iv 密钥偏移量
 */
- (NSData *)decryptedTripleDESAndCBCDataUsingKey:(id)key vector:(id)iv;
{
    NSData * result = [self decryptedDataUsingAlgorithm:kCCAlgorithm3DES key:key initializationVector:iv options:kCCOptionPKCS7Padding];
    return ( result );
}


#pragma mark ===============CAS===============
- (NSData *)CASTEncryptedDataUsingKey:(id)key
{
    NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmCAST
                                                    key: key
                                                options: kCCOptionPKCS7Padding];
    return ( result );
}

- (NSData *)decryptedCASTDataUsingKey:(id)key
{
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmCAST
                                                    key: key
                                                options: kCCOptionPKCS7Padding
                                                 ];
    return ( result );
}

#pragma mark ===============加密===============
/**
 *  @brief  根据密钥、加密算法等kCCOptionPKCS7Padding补位加密(没有iv密钥偏移量)
 *  @param  alg     加密算法
 *  @param  key     未转Data字节数据的密钥
 *  @return result  操作后加密的数据
 */
- (NSData *)dataEncryptedUsingAlgorithm: (CCAlgorithm)alg
                                    key: (id) key
{
    //kCCOptionPKCS7Padding是缺几位，就补几个几，如：缺3位，补3个3，缺5位，补5个5
    return ( [self dataEncryptedUsingAlgorithm:alg key:key options:kCCOptionPKCS7Padding] );
}

/**
 *  @brief  根据密钥、加密算法等加密(没有iv密钥偏移量)
 *  @param  alg     加密算法
 *  @param  options 补码方式,块加密只能对特定长度的数据块进行加密，CBC、ECB模式需要在最后一数据块加密前进行数据填充
 *  @param  key     未转Data字节数据的密钥
 *  @return result  操作后的数据（加密／解密）
 */
- (NSData *)dataEncryptedUsingAlgorithm: (CCAlgorithm)alg
                                    key: (id)key
                                options: (CCOptions)options
{
    return ( [self dataEncryptedUsingAlgorithm:alg key:key initializationVector:nil options:options] );
}

/**
 *  @brief  根据密钥、加密算法等加密
 *  @param  alg     加密算法
 *  @param  options 补码方式,块加密只能对特定长度的数据块进行加密，CBC、ECB模式需要在最后一数据块加密前进行数据填充
 *  @param  key     未转Data字节数据的密钥
 *  @param  iv      密钥偏移量，可选
 *  @return result  操作后的数据（加密／解密）
 */
- (NSData *)dataEncryptedUsingAlgorithm: (CCAlgorithm)alg
                                   key: (id)key
                  initializationVector: (id)iv
                               options: (CCOptions)options
{
    return ( [self dataUsingAlgorithm:alg operation:kCCEncrypt key:key initializationVector:iv options:options] );
}

#pragma mark ===============解密===============
/**
 *  @brief  根据密钥、加密算法等kCCOptionPKCS7Padding补位解密(没有iv密钥偏移量)
 *  @param  alg     加密算法
 *  @param  key     未转Data字节数据的密钥
 *  @return result  操作后的数据（加密／解密）
 */
- (NSData *)decryptedDataUsingAlgorithm: (CCAlgorithm)alg
                                    key: (id) key
{
    //kCCOptionPKCS7Padding是缺几位，就补几个几，如：缺3位，补3个3，缺5位，补5个5
    return ( [self decryptedDataUsingAlgorithm:alg key:key options:kCCOptionPKCS7Padding] );
}

/**
 *  @brief  根据密钥、加密算法等解密(没有iv密钥偏移量)
 *  @param  alg     加密算法
 *  @param  options 补码方式,块加密只能对特定长度的数据块进行加密，CBC、ECB模式需要在最后一数据块加密前进行数据填充
 *  @param  key     未转Data字节数据的密钥
 *  @return result  操作后的数据（加密／解密）
 */
- (NSData *)decryptedDataUsingAlgorithm: (CCAlgorithm)alg
                                    key: (id)key
                                options: (CCOptions)options
{
    return ( [self decryptedDataUsingAlgorithm:alg key:key initializationVector:nil options:options] );
}

/**
 *  @brief  根据密钥、加密算法等解密
 *  @param  alg     加密算法
 *  @param  options 补码方式,块加密只能对特定长度的数据块进行加密，CBC、ECB模式需要在最后一数据块加密前进行数据填充
 *  @param  key     未转Data字节数据的密钥
 *  @param  iv      密钥偏移量，可选
 *  @return result  操作后的数据（加密／解密）
 */
- (NSData *)decryptedDataUsingAlgorithm: (CCAlgorithm)alg
                                   key: (id)key
                  initializationVector: (id)iv
                               options: (CCOptions)options
{
    return ( [self dataUsingAlgorithm:alg operation:kCCDecrypt key:key initializationVector:iv options:options] );
}

#pragma mark =============加密／解密操作==========
/*  CCAlgorithm {
     kCCAlgorithmAES128 = 0,
     kCCAlgorithmAES = 0,
     kCCAlgorithmDES,
     kCCAlgorithm3DES,
     kCCAlgorithmCAST,
     kCCAlgorithmRC4,
     kCCAlgorithmRC2,
     kCCAlgorithmBlowfish
     };
 */

/**
 *  @brief  根据密钥、加密算法等加密／解密数据
 *  @param  alg     加密算法
 *  @param  op      0:kCCEncrypt(加密), 1:kCCDecrypt(解密)
 *  @param  options 补码方式,块加密只能对特定长度的数据块进行加密，CBC、ECB模式需要在最后一数据块加密前进行数据填充
 *  @param  key     未转Data字节数据的密钥
 *  @param  iv      密钥偏移量，可选
 *  @return result  操作后的数据（加密／解密）
 */
- (NSData *)dataUsingAlgorithm: (CCAlgorithm)alg
                     operation: (CCOperation)op
                           key: (id)key
          initializationVector: (id)iv
                       options: (CCOptions)options
{
    CCCryptorRef cryptor = NULL;

    NSParameterAssert([key isKindOfClass: [NSData class]] || [key isKindOfClass: [NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass: [NSData class]] || [iv isKindOfClass: [NSString class]]);

    NSMutableData * keyData, * ivData;
    if ( [key isKindOfClass: [NSData class]] ) {
        keyData = (NSMutableData *) [key mutableCopy];
    } else {
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    }

    if ( [iv isKindOfClass: [NSData class]] ) {
        ivData = (NSMutableData *) [iv mutableCopy];
    } else {
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    }

//#if !__has_feature(objc_arc)
//    [keyData autorelease];
//    [ivData autorelease];
//#endif

    // ensure correct lengths for key and iv data, based on algorithms
    FixKeyLengths(alg, keyData, ivData );
    /**
     *  CCAlgorithm -> alg   定义加密算法
     *  CCOperation -> op    定义基本的操作： kCCEncrypt(加密)                kCCDecrypt(解密)
     *  CCOptions -> options
     *  key                  未转Data字节数据的密钥
     *  keyLength            转Data字节数据的密钥长度
     *  iv                   初始化向量，可选
     *  CCCryptorRef -> cryptorRef
     *  dataIn               加密使用的向量参数，cbc模式需要，16个字节，ecb模式不需要
     *  dataInLength         待加密解密数据的长度
     *  dataOut              输出已加密串的内存地址(结果被写入这里。通过回调被分配任务。)
     *  dataOutAvailable     输出数据时需要的可用空间大小
     *  dataOutMoved         成功之后实际占用的空间大小.
     */
    //CCCrypt(CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, size_t keyLength, const void *iv, const void *dataIn, size_t dataInLength, void *dataOut, size_t dataOutAvailable, size_t *dataOutMoved)
    //  加密、解密数据，采用库中的CCCrypt方法，这个方法会按次序执行CCCrytorCreate(),
    // CCCryptorUpdate(), CCCryptorFinal(), and CCCryptorRelease() 如果开自己create这个对象，
    //那么后面就必须执行final、release之类的函数，CCCrypt方法一次性解决

    //创建加密器CCCryptorRef
    CCCryptorStatus status = CCCryptorCreate(op,alg, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor );

    // 执行update,final，获取data
    NSData * result = [self runCryptor: cryptor result: &status];
    //
    CCCryptorRelease( cryptor );

    return ( result );
}

/** @brief CCCryptorUpdate(), CCCryptorFinal()*/
- (NSData *)runCryptor:(CCCryptorRef)cryptor result: (CCCryptorStatus *)status
{
    //  CCCryptorGetOutputLength: 确定处理给定输入大小所需的输出缓冲区大小。一些一般规则适用于允许该模块的客户预先知道在给定情况下需要多少输出缓冲区空间。流密码，输出的大小总是等于输入的大小，和cccryptorfinal()不会产生任何数据。对于分组密码，输出大小总是小于或等于输入大小加上一个块的大小。块密码，如果提供给每个电话cccryptorupdate()输入大小是块大小的整数倍，则每次调用cccryptorupdate()输出的大小是小于或等于输入大小的称cccryptorupdate()。cccryptorfinal()只产生输出时使用的垫块密码启用。
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[self length], true );
    void * buf = malloc( bufsize );
    size_t bufused = 0;
    size_t bytesTotal = 0;
    
    //加密处理
    *status = CCCryptorUpdate(cryptor, [self bytes], (size_t)[self length],buf, bufsize, &bufused );
    if ( *status != kCCSuccess )
    {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    //处理最后的数据块
    *status = CCCryptorFinal( cryptor, buf + bufused, bufsize - bufused, &bufused );
    if ( *status != kCCSuccess )
    {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    return ( [NSData dataWithBytesNoCopy: buf length: bytesTotal] );
}

@end
