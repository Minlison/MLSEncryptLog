//
//  MLSEncryptFileStream.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLSEncryptLogFileItem.h"
@interface MLSEncryptFileStream : NSObject

/**
 文件流类型
 */
@property (assign, nonatomic, readonly) MLSEncryptFileStreamType streamType;

/**
 当前操作的文件 item
 如果当前的 item 不可写入, 会重新创建
 如果当前的 item 读取完毕, 会自动查询下一个
 */
@property (strong, nonatomic, readonly) MLSEncryptLogFileItem *fileItem;

/**
 找出当前有效的 item
 如果是写的文件流,那么会找最新的文件,检查是否可以拼接,如果可以拼接, 当前的 fileitem 更新,如果不可以拼接,则创建新的 log 文件
 如果是读文件流,如果当前文件读完,那么久会找下一个文件,直到找不到文件为止

 @return 是否有效
 */
- (BOOL)findCurrentAvailabileItem;

- (BOOL)findNextAvailabileItem;
@end
