//
//  MLSEncryptAES.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLSEncryptAES : NSObject

/**
 加密

 @param data 加密数据
 @return 加密后的数据
 */
+ (NSData *)encryptData:(NSData *)data;

/**
 解密

 @param data 解密前的数据
 @return 解密后的数据
 */
+ (NSData *)decryptData:(NSData *)data;
@end
