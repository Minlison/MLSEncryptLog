//
//  MLSEncryptLogManager.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptLogFileItem.h"
@interface MLSEncryptLogManager : NSObject

/**
 存储字符串

 @param string  str
 */
+ (void)logString:(NSString *)string;


/**
 获取解密后的文件

 @param completion 完成回调
 */
+ (void)getDecryptLogFileItems:(void (^)(NSArray <MLSEncryptLogFileItem *> *items))completion;

/**
 获取解密文件

 @param logDir 加密日志文件夹, 如果为空, 则解密当前系统下的加密日志
 @param completion 完成回调
 */
+ (void)getDecryptLogFileItemsFromDir:(NSString *)logDir completion:(void (^)(NSArray <MLSEncryptLogFileItem *> *items))completion;


@end

FOUNDATION_EXPORT void MLSEncryptLog(NSString *format, ...);
#define MLSLog(fmt, ...) MLSEncryptLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
