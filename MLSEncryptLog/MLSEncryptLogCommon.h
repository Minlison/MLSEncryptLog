//
//  MLSEncryptCommon.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#ifndef MLSEncryptCommon_h
#define MLSEncryptCommon_h
#import <Foundation/Foundation.h>

/// 日志过滤
typedef BOOL (^MLSEncryptLogFilter)(NSString *str);

/**
 文件item 类型

 - MLSEncryptLogFileItemTypeWrite: 写
 - MLSEncryptLogFileItemTypeRead: 读
 */
typedef NS_ENUM(int, MLSEncryptLogFileItemType)
{
	MLSEncryptLogFileItemTypeNone = 0,
	MLSEncryptLogFileItemTypeWrite = 1,
	MLSEncryptLogFileItemTypeRead = 2,
};


/**
 文件流类型

 - MLSEncryptFileStreamTypeWrite: 写
 - MLSEncryptFileStreamTypeRead: 读
 */
typedef NS_ENUM(int,MLSEncryptFileStreamType)
{
	MLSEncryptFileStreamTypeWrite  = 1,
	MLSEncryptFileStreamTypeRead  = 2,
};




#endif /* MLSEncryptCommon_h */
