//
//  MLSEncryptLog.h
//  MLSEncryptLog
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//
/*
 使用说明:
 使用 MLSLog 宏定义打印日志.
 使用 MLSEncryptLogConfig 配置
 使用 MLSEncryptLogManager 解密当前 log 日志系统加密文件解密文件 或者 是指定加密日志文件存在的文件夹的文件
 
 */



#import <Cocoa/Cocoa.h>

//! Project version number for MLSEncryptLog.
FOUNDATION_EXPORT double MLSEncryptLogVersionNumber;

//! Project version string for MLSEncryptLog.
FOUNDATION_EXPORT const unsigned char MLSEncryptLogVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MLSEncryptLog/PublicHeader.h>

#if __has_include(<MLSEncryptLog/MLSEncryptLog.h>)
#import <MLSEncryptLog/MLSEncryptLogCommon.h>

#import <MLSEncryptLog/MLSEncryptLogConfig.h>
#import <MLSEncryptLog/MLSEncryptLogFileItem.h>
#import <MLSEncryptLog/MLSEncryptLogManager.h>

#else

#import "MLSEncryptLogCommon.h"

#import "MLSEncryptLogConfig.h"
#import "MLSEncryptLogFileItem.h"
#import "MLSEncryptLogManager.h"

#endif
