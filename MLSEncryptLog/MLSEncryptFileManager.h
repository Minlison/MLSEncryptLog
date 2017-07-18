//
//  MLSEncryptFileManager.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptLogFileItem.h"

#define  MLSEncryptFileManagerShareInstance [MLSEncryptFileManager sharedInstance]

@interface MLSEncryptFileManager : NSObject

/**
 单例
 会读取日志目录下的所有日志文件,
 可以更改日志目录
 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 日志文件
 按照先后创建的顺序依次排列
 */
@property (strong, nonatomic, readonly) NSArray <MLSEncryptLogFileItem *> *logFileItems;

/**
 解密后的日志文件
 */
@property (strong, nonatomic, readonly) NSArray <MLSEncryptLogFileItem *> *decryptLogFileItems;

/**
 日志目录

 @param logDir 日志存放目录
 */
- (void)setLogDirectory:(NSString *)logDir autoCreate:(BOOL)autoCreate;

/**
 解密后的日志文件夹

 @param decryptlogDir 文件夹
 @param autoCreate 不存在就自动创建
 */
- (void)setDecryptLogDirectory:(NSString *)decryptlogDir autoCreate:(BOOL)autoCreate;

/**
 找到文件下最新的文件
 
 @param directory 目录
 @return 文件Item
 */
- (MLSEncryptLogFileItem *)findLastedFileInDirectory:(NSString *)directory;

/**
 排序目录下的文件
 按照日期创建的先后排序, 最早创建的在最前面
 @param directory 文件夹
 @return fileItems
 */
- (NSArray <MLSEncryptLogFileItem *>*)sortFilesUseCreateDateInDirectory:(NSString *)directory;

/**
 快速创建 Log 文件
 
 @param directory 文件夹
 @param error 是否错误
 @return 创建成功的 FileItem
 */
- (MLSEncryptLogFileItem *)createLogFileAtDirectory:(NSString *)directory error:(NSError **)error;


/**
 快速创建 解密后的 Log 文件
 
 @param fileItem 文件夹
 @param error 是否错误
 @return 创建成功的 FileItem
 */
- (MLSEncryptLogFileItem *)createDecryptLogFileFor:(MLSEncryptLogFileItem *)fileItem error:(NSError **)error;


@end
