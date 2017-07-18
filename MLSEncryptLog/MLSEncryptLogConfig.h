//
//  MLSEncryptLogConfig.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptLogCommon.h"

#define MLSEncryptLogShareConfig [MLSEncryptLogConfig shareConfig]
@interface MLSEncryptLogConfig : NSObject

/**
 单例
 */
+ (instancetype)shareConfig;

/**
 设置是否加密, 默认为 YES
 */
@property (assign, nonatomic) BOOL encrypt;
/**
 是否允许终端输出
 */
@property (assign, nonatomic) BOOL consoleEnable;
/**
 过滤器
 */
@property (copy, nonatomic) MLSEncryptLogFilter logFilter;

/**
 日志文件夹
 */
@property (copy, nonatomic) NSString *logDirectory;

/**
 解密日志文件夹
 */
@property (copy, nonatomic) NSString *decryptDirectory;

/**
 单个文件最大大小 单位 KB
 默认 10MB
 */
@property (assign, nonatomic) NSUInteger singleFileMaxLength;

/**
 文件类型/ 后缀
 */
@property (copy, nonatomic) NSString *fileType;

/**
  日志系统队列
 */
@property (strong, nonatomic, readonly) dispatch_queue_t log_queue;

/**
 读取日志队列
 */
@property (strong, nonatomic, readonly) dispatch_queue_t read_queue;
@end
