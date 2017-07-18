
//  MLSEncryptLogFileItem.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptLogFileItem.h"
#import "MLSEncryptLogConfig.h"
#import "MLSEncryptLogEncrypt.h"

@interface MLSEncryptLogFileItem()
{
	FILE * fileFP;
}
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSString *path;
@property (copy, nonatomic, readwrite) NSString *fileType;
@property (strong, nonatomic, readwrite) NSDate *createDate;
@property (strong, nonatomic, readwrite) NSDate *modifiyDate;
@property (assign, nonatomic, readwrite) NSUInteger length;
@property (assign, nonatomic, readwrite) MLSEncryptLogFileItemType type;
@property (assign, nonatomic, readwrite) NSUInteger readLength;
@property (assign, nonatomic) BOOL isOpenFile;
@end
@implementation MLSEncryptLogFileItem
+ (instancetype)encryptLogFileItemWithFileAttribute:(NSDictionary *)fileAttribute atPath:(NSString *)path
{
	if (!fileAttribute) {
		return nil;
	}
	MLSEncryptLogFileItem *item = [[MLSEncryptLogFileItem alloc] init];
	item.readLength = 0;
	item.length = [fileAttribute fileSize];
	item.path = path;
	item.name = path.lastPathComponent.stringByDeletingPathExtension;
	item.createDate = [fileAttribute fileCreationDate];
	item.modifiyDate = [fileAttribute fileModificationDate];
	item.fileType = path.pathExtension;
	return item;
}
- (BOOL)isRealyLogFile
{
	if (self.path) {
		FILE *fp = fopen([self.path cStringUsingEncoding:NSUTF8StringEncoding], "a+b");
		fseek(fp, 0, SEEK_SET);
		NSData *headerData = [MLSEncryptLogEncrypt getFileHeader];
		size_t length = headerData.length;
		void *bytes = malloc(length);
		memset(bytes, 0, length);
		size_t readed = fread(bytes, sizeof(char), length, fp);
		NSData *fileHeader = [NSData dataWithBytes:bytes length:readed];
		
		fclose(fp);
		free(bytes);
		
		if (readed == length) {
			return [fileHeader isEqualToData:headerData];
		}
		return NO;
	}
	return NO;
}

- (BOOL)canWrite
{
	if (self.length >= (MLSEncryptLogShareConfig.singleFileMaxLength * 1000 )) {
		return NO;
	}
	return YES;
}
- (BOOL)isReadEnd
{
	return self.readLength == self.length;
}
- (BOOL)writeData:(NSData *)data
{
	if (NULL != fileFP)
	{
		size_t length = fwrite([data bytes], data.length, 1, fileFP);
		BOOL success = (length == 1);
		if (success)
		{
			NSLog(@"decrypt write data %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
			self.length += [data length];
		}
		return success;
	}
	return NO;
}
- (NSData *)readDataLength:(NSUInteger)length
{

	if (NULL != fileFP)
	{
		void *bytes = malloc((size_t)length);
		memset(bytes, 0, (size_t)length);
		size_t readed = fread(bytes, sizeof(char), length, fileFP);
		if (readed <= length) { // 表示读取成功
			
			NSData *data = [NSData dataWithBytes:bytes length:readed];
			self.readLength += data.length;
			free(bytes);
			return data;
		}
		free(bytes);
		return nil;
	}
	return nil;
}

- (void)openFileWithType:(MLSEncryptLogFileItemType)type
{
	if (self.type != type)
	{
		[self close];
	}
	
	if (self.isOpenFile)
	{
		return;
	}
	self.isOpenFile = YES;
	self.type = type;
	if (NULL == fileFP && self.path)
	{
		fileFP = fopen([self.path cStringUsingEncoding:NSUTF8StringEncoding], "a+b");
	}
	[self resetFileWithType:type];
	
}
- (void)resetFileWithType:(MLSEncryptLogFileItemType)type
{
	if (NULL != fileFP)
	{
		if (type == MLSEncryptLogFileItemTypeWrite) {
			fseek(fileFP, 0, SEEK_END); // seek 到最后
			self.length = ftell(fileFP); // 获取精确字节数
		} else if (type == MLSEncryptLogFileItemTypeRead) {
			fseek(fileFP, 0, SEEK_SET); // seek 到文件开头
			self.readLength = 0;
		}
	}
}
- (void)close
{
	if (NULL != fileFP) {
		fclose(fileFP);
		fileFP = NULL;
		self.isOpenFile = NO;
		NSLog(@"close file item %@",self.path);
	}
}
- (MLSEncryptLogFileItemType)fileItemType
{
	NSAssert(NO, @"子类实现");
	return MLSEncryptLogFileItemTypeRead;
}
- (void)dealloc
{
	[self close];
}

- (NSString *)description
{
	NSDictionary *infoDirectory = @{
					@"name" : self.name,
					@"path" : self.path,
					@"fileType" : self.fileType,
					@"createDate" : self.createDate,
					@"modifiyDate" : self.modifiyDate,
					@"length" : @(self.length),
					@"type" : @(self.type),
					@"readLength" : @(self.readLength)
					};
	NSString *des = nil;
	if ([NSJSONSerialization isValidJSONObject:infoDirectory])
	{
		NSData *data = [NSJSONSerialization dataWithJSONObject:infoDirectory options:(NSJSONWritingPrettyPrinted) error:nil];
		des = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	if (!des)
	{
		des = infoDirectory.description;
	}
	return des;
}
@end
