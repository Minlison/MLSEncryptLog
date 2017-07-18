//
//  MLSEncryptReader.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptFileStream.h"
#import "MLSEncryptLogFileItem.h"
@interface MLSEncryptReader : MLSEncryptFileStream

/**
 解密加密的日志
 */
+ (NSArray <MLSEncryptLogFileItem *> *)decrypt;

/**
 解密对应文件夹下的加密日志文件

 @param logdir 加密日志文件夹
 */
+ (NSArray <MLSEncryptLogFileItem *> *)decryptInDir:(NSString *)logdir;
@end
