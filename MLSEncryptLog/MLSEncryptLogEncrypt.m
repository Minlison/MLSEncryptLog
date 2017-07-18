//
//  MLSEncryptLogEncrypt.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptLogEncrypt.h"
#import "MLSEncryptLogConfig.h"
#import "MLSEncryptAES.h"

@implementation MLSEncryptLogEncrypt

+ (NSData *)encryptData:(NSData *)data
{
	NSMutableData *mutableData = [NSMutableData data];
	
	/// 拼接数据
	if (MLSEncryptLogShareConfig.encrypt)
	{
		NSData *tmp = [MLSEncryptAES encryptData:data];
		/// 拼接长度
		int length = (int)tmp.length;
		[mutableData appendBytes:&length length:4];
		[mutableData appendData:tmp];
	}
	else
	{
		/// 拼接长度
		int length = (int)data.length;
		[mutableData appendBytes:&length length:4];
		[mutableData appendData:data];
	}
	return mutableData;
}
+ (BOOL)startDecryptFileItem:(MLSEncryptLogFileItem *)item error:(NSError **)error
{
	if (!item)
	{
		if (error)
		{
			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"文件空"}];
		}
		return NO;
	}
	[item openFileWithType:(MLSEncryptLogFileItemTypeRead)];
	NSData *data = [item readDataLength:[self headerLength]];
	if (![data isEqualToData:[self getFileHeader]])
	{
		if (error)
		{
			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"文件格式错误"}];
		}
		[self endDecryptFileItem:item];
		return NO;
	}
	return YES;
}
+ (NSData *)decryptOnce:(MLSEncryptLogFileItem *)item
{
	if (!item || [item isReadEnd]) {
		return nil;
	}
	NSData *fileLengthData = [item readDataLength:4];
	int length = 0;
	[fileLengthData getBytes:&length length:4];
	
	if (length == 0 || length > item.length)
	{
		return nil;
	}
	
	NSData *readData = [item readDataLength:length];
	readData = [MLSEncryptAES decryptData:readData];
	return readData;
}
+ (void)endDecryptFileItem:(MLSEncryptLogFileItem *)item
{
	if (item)
	{
		[item close];
	}
}

+ (NSData *)getFileHeader
{
	char header[6] = {'m','l','s','l','o','g'};
	return [NSData dataWithBytes:(void *)header length:6];
}
+ (NSUInteger)headerLength
{
	return 6;
}
@end
