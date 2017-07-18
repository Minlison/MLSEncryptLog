//
//  MLSEncryptWriter.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptFileStream.h"

@interface MLSEncryptWriter : MLSEncryptFileStream

/**
 写入数据

 @param data 数据
 */
+ (void)writeData:(NSData *)data;

/**
 写入字符串

 @param string 字符串
 */
+ (void)writeString:(NSString *)string;

@end
