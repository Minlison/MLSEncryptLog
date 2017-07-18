//
//  MLSEncryptLogFileItem.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptLogCommon.h"

@interface MLSEncryptLogFileItem : NSObject

/**
 文件名
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 文件路径
 */
@property (copy, nonatomic, readonly) NSString *path;

/**
 文件类型
 */
@property (copy, nonatomic, readonly) NSString *fileType;

/**
 创建日期
 */
@property (strong, nonatomic, readonly) NSDate *createDate;

/**
 最新修改时间
 */
@property (strong, nonatomic, readonly) NSDate *modifiyDate;

/**
 文件大小
 */
@property (assign, nonatomic, readonly) NSUInteger length;


/**
 读取的长度, 最大值不超过 length
 */
@property (assign, nonatomic, readonly) NSUInteger readLength;


/**
 类型 读/写
 */
@property (assign, nonatomic, readonly) MLSEncryptLogFileItemType type;

/**
 快速创建

 @param fileAttribute 文件属性(NSFileManager 读取)
 @param path 文件路径
 @return  item
 */
+ (instancetype)encryptLogFileItemWithFileAttribute:(NSDictionary *)fileAttribute atPath:(NSString *)path;


/**
 是否可以写入数据
 */
- (BOOL)canWrite;

/**
 是否读取到最后

 @return 是否读取到最后
 */
- (BOOL)isReadEnd;

/**
 写入数据

 @param data 数据
 @return 是否写入成功
 */
- (BOOL)writeData:(NSData *)data;

/**
 读取响应长度的数据

 @param length 数据长度
 @return 读取到的数据
 */
- (NSData *)readDataLength:(NSUInteger)length;

/**
 是否是加密文件

 @return 是否是加密文件
 */
- (BOOL)isRealyLogFile;

/**
 打开文件
 */
- (void)openFileWithType:(MLSEncryptLogFileItemType)type;

/**
 重置文件指针

 @param type 文件类型
 */
- (void)resetFileWithType:(MLSEncryptLogFileItemType)type;
/**
 关闭文件
 */
- (void)close;
@end

