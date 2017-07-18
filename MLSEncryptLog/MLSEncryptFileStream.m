//
//  MLSEncryptFileStream.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptFileStream.h"
#import "MLSEncryptFileManager.h"
#import "MLSEncryptLogConfig.h"

@interface MLSEncryptFileStream()
@property (strong, nonatomic, readwrite) MLSEncryptLogFileItem *fileItem;
@end
@implementation MLSEncryptFileStream
+ (instancetype)streamWithFileItem:(MLSEncryptLogFileItem *)item
{
	MLSEncryptFileStream *stream = [[MLSEncryptFileStream alloc] init];
	stream.fileItem = item;
	return stream;
}
- (BOOL)findCurrentAvailabileItem
{
	if (self.streamType == MLSEncryptFileStreamTypeWrite)
	{
		[self findFileItemForWriteWithCreateNext:NO];
	}
	else
	{
		[self findFileItemForReadNext:NO];
	}
	return (self.fileItem != nil);
}
- (BOOL)findNextAvailabileItem
{
	if (self.streamType == MLSEncryptFileStreamTypeWrite)
	{
		[self findFileItemForWriteWithCreateNext:YES];
	}
	else
	{
		[self findFileItemForReadNext:YES];
	}
	return (self.fileItem != nil);
}
- (void)findFileItemForReadNext:(BOOL)next
{
	if (next)
	{
		[self findNextFileItemForRead];
	}
	else
	{
		if ( !self.fileItem )
		{
			[self replaceFileItemWithItem:MLSEncryptFileManagerShareInstance.logFileItems.firstObject openFileWithType:MLSEncryptLogFileItemTypeRead];
		}
		else /// 读取完毕
		{
			[self findNextFileItemForRead];
		}
	}
	
}

- (void)replaceFileItemWithItem:(MLSEncryptLogFileItem *)item openFileWithType:(MLSEncryptLogFileItemType)type
{
	[self.fileItem close];
	self.fileItem = nil;
	self.fileItem = item;
	if (self.fileItem)
	{
		[self.fileItem openFileWithType:(type)];
	}
}
- (void)findFileItemForWriteWithCreateNext:(BOOL)next
{
	if (next)
	{
		[self createFileItemForWrite];
	}
	else
	{
		MLSEncryptLogFileItem *item = MLSEncryptFileManagerShareInstance.logFileItems.lastObject;
		
		if (self.fileItem != item)
		{
			if ( [item canWrite] )
			{
				[self replaceFileItemWithItem:item openFileWithType:MLSEncryptLogFileItemTypeWrite];
			}
			else
			{
				[self createFileItemForWrite];
			}
		}
		else
		{
			/// 不可写入就创建
			if ( ![self.fileItem canWrite] )
			{
				[self createFileItemForWrite];
			}
		}
	}
	
	
}
- (BOOL)findNextFileItemForRead
{
	if (self.fileItem == nil)
	{
		return NO;
	}
	/// 表示当前日志是在内存中
	if ( [MLSEncryptFileManagerShareInstance.logFileItems containsObject:self.fileItem] )
	{
		/// 没有读取到最后一个
		if (MLSEncryptFileManagerShareInstance.logFileItems.lastObject != self.fileItem )
		{
			if ([self.fileItem isReadEnd])
			{
				NSUInteger index = [MLSEncryptFileManagerShareInstance.logFileItems indexOfObject:self.fileItem];
				
				if (index < MLSEncryptFileManagerShareInstance.logFileItems.count - 1)
				{
					[self replaceFileItemWithItem:MLSEncryptFileManagerShareInstance.logFileItems[index + 1] openFileWithType:MLSEncryptLogFileItemTypeRead];
					return YES;
				}
				else
				{
					[self replaceFileItemWithItem:nil openFileWithType:MLSEncryptLogFileItemTypeNone];
					return NO;
				}
			}
		}
		else
		{
			/// 日志读取完毕
			[self replaceFileItemWithItem:nil openFileWithType:MLSEncryptLogFileItemTypeNone];
			return NO;
		}
	}
	else
	{
		[self replaceFileItemWithItem:nil openFileWithType:MLSEncryptLogFileItemTypeNone];
		return NO;
	}
	return NO;
}
- (BOOL)createFileItemForWrite
{
	
	NSError *error = nil;
	MLSEncryptLogFileItem *item = [MLSEncryptFileManagerShareInstance createLogFileAtDirectory:MLSEncryptLogShareConfig.logDirectory error:&error];
	if (!error)
	{
		[self replaceFileItemWithItem:item openFileWithType:(MLSEncryptLogFileItemTypeWrite)];
	}
	else
	{
		[self replaceFileItemWithItem:nil openFileWithType:(MLSEncryptLogFileItemTypeNone)];
	}
	return (error == nil);
}
@end
