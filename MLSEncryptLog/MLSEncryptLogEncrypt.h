//
//  MLSEncryptLogEncrypt.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptLogFileItem.h"
@interface MLSEncryptLogEncrypt : NSObject

/**
 加密

 @param data 加密
 @return 加密后的 data
 */
+ (NSData *)encryptData:(NSData *)data;

/**
 文件头

 @return 文件头
 */
+ (NSData *)getFileHeader;

/**
 文件头长度

 @return 长度
 */
+ (NSUInteger)headerLength;


/**
 开始解密文件

 @param item 文件
 @param error 是否可以解密
 @return 是否可以解密
 */
+ (BOOL)startDecryptFileItem:(MLSEncryptLogFileItem *)item error:(NSError **)error;

/**
 结束解密文件

 @param item 文件
 */
+ (void)endDecryptFileItem:(MLSEncryptLogFileItem *)item;

/**
 解密一次, 数据如果返回为空,代表解密完毕

 @param item 文件
 @return 解密后的数据
 */
+ (NSData *)decryptOnce:(MLSEncryptLogFileItem *)item;
@end
