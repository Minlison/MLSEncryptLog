//
//  MLSEncryptFileManager.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 Minlison. All rights reserved.
//

#import "MLSEncryptFileManager.h"
#import "MLSEncryptLogConfig.h"
#import "MLSEnryptHelper.h"
#import "MLSEncryptLogEncrypt.h"
#import <Cocoa/Cocoa.h>

@interface MLSEncryptFileManager()
@property (copy, nonatomic, readwrite) NSString *decryptLogDir;
@property (copy, nonatomic, readwrite) NSString *logDir;
@property (strong, nonatomic, readwrite) NSArray <MLSEncryptLogFileItem *> *logFileItems;
@property (strong, nonatomic, readwrite) NSArray <MLSEncryptLogFileItem *> *decryptLogFileItems;
@property (assign, nonatomic) BOOL isConfiged;
@end
@implementation MLSEncryptFileManager
+ (instancetype)sharedInstance {
	static dispatch_once_t MLSEncryptFileManageronceToken;
	static MLSEncryptFileManager *instance = nil;
	dispatch_once(&MLSEncryptFileManageronceToken,^{
		instance = [[MLSEncryptFileManager alloc] init];
	});
	[instance config];
	return instance;
}
- (void)config
{
	if (self.isConfiged) {
		return;
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate) name:NSApplicationWillTerminateNotification object:nil];
	self.isConfiged = YES;
	[self setLogDirectory:MLSEncryptLogShareConfig.logDirectory autoCreate:YES];
	[self setDecryptLogDirectory:MLSEncryptLogShareConfig.decryptDirectory autoCreate:YES];
}
- (void)applicationWillTerminate
{
	[self.logFileItems enumerateObjectsUsingBlock:^(MLSEncryptLogFileItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj close];
	}];
	
	[self.decryptLogFileItems enumerateObjectsUsingBlock:^(MLSEncryptLogFileItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj close];
	}];
}
- (void)setLogDirectory:(NSString *)logDir autoCreate:(BOOL)autoCreate
{
	if (autoCreate) {
		[self createDirectoryForPath:logDir];
	}
	self.logDir = logDir;
	self.logFileItems = [self sortFilesUseCreateDateInDirectory:logDir];
}
- (void)setDecryptLogDirectory:(NSString *)decryptlogDir autoCreate:(BOOL)autoCreate
{
	if (autoCreate)
	{
		[self createDirectoryForPath:decryptlogDir];
	}
	self.decryptLogDir = decryptlogDir.copy;
}
- (BOOL)createDirectoryForPath:(NSString *)path
{
	if (!path) {
		return NO;
	}
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL isDir = NO;
	BOOL isExist = [manager fileExistsAtPath:path isDirectory:&isDir];
	/// 不存在,或者不是文件夹,就创建
	if (!isExist || !isDir) {
		NSError *error = nil;
		[manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
		return (error == nil);
	}
	return YES;
}

- (MLSEncryptLogFileItem *)findLastedFileInDirectory:(NSString *)directory
{
	return [self sortFilesUseCreateDateInDirectory:directory].lastObject;
}

- (NSArray <MLSEncryptLogFileItem *>*)sortFilesUseCreateDateInDirectory:(NSString *)directory
{
	if (!directory) {
		return nil;
	}
	NSString *tmpPath = directory.copy;
	NSString *tmpFileName = nil;
	NSString *tmpFilePath = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSDirectoryEnumerator <NSString *>*enumerator = [fileManager enumeratorAtPath:directory];
	NSMutableArray <MLSEncryptLogFileItem *>*contents = [NSMutableArray array];
	
	while ( tmpFileName = [enumerator nextObject] )
	{
		// 过滤非本框架的log 文件
		if (![tmpFileName hasSuffix:MLSEncryptLogShareConfig.fileType])
		{
			continue;
		}
		
		// 拼接绝对路径
		tmpFilePath = [tmpPath stringByAppendingPathComponent:tmpFileName];
		
		NSError *error = nil;
		NSDictionary *fileAttribute = [fileManager attributesOfItemAtPath:tmpFilePath error:&error];
		if (!error) {
			MLSEncryptLogFileItem *item = [MLSEncryptLogFileItem encryptLogFileItemWithFileAttribute:fileAttribute atPath:tmpFilePath];
			if ([item isRealyLogFile])
			{
				[contents addObject:item];
			}
		}
	}
	
	[contents sortUsingComparator:^NSComparisonResult(MLSEncryptLogFileItem *  _Nonnull obj1, MLSEncryptLogFileItem *  _Nonnull obj2) {
		return ([obj1.createDate timeIntervalSince1970] > [obj2.createDate timeIntervalSince1970]);
	}];
	
	return contents;
}

- (MLSEncryptLogFileItem *)createLogFileAtDirectory:(NSString *)directory error:(NSError **)error
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fileName = [[MLSEnryptHelper currentTimeString] stringByAppendingPathExtension:MLSEncryptLogShareConfig.fileType];
	NSString *filePath = [MLSEncryptLogShareConfig.logDirectory stringByAppendingPathComponent:fileName];
	BOOL res = [fileManager createFileAtPath:filePath contents:[MLSEncryptLogEncrypt getFileHeader] attributes:nil];
	if (!res) {
		if (error) {
			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"创建日志文件失败"}];
		}
		return nil;
	}
	NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:filePath error:error];
	MLSEncryptLogFileItem *item = [MLSEncryptLogFileItem encryptLogFileItemWithFileAttribute:fileAttr atPath:filePath];
	if (item) {
		if (self.logFileItems) {
			NSMutableArray *array = [NSMutableArray arrayWithArray:self.logFileItems];
			[array addObject:item];
			self.logFileItems = array;
		} else {
			self.logFileItems = @[item];
		}
	}
	return item;
}

- (MLSEncryptLogFileItem *)createDecryptLogFileFor:(MLSEncryptLogFileItem *)fileItem error:(NSError **)error
{
	if (!fileItem) {
		return nil;
	}
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fileName = [fileItem.name stringByAppendingPathExtension:@"txt"];
	NSString *filePath = [MLSEncryptLogShareConfig.decryptDirectory stringByAppendingPathComponent:fileName];
	
	if ([fileManager fileExistsAtPath:filePath]) // 文件存在
	{
		/// 放到垃圾篓
		[fileManager removeItemAtURL:[NSURL fileURLWithPath:filePath] error:nil];
	}
	BOOL res = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
	if (!res) {
		if (error) {
			*error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"创建日志文件失败"}];
		}
		return nil;
	}
	NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:filePath error:error];
	MLSEncryptLogFileItem *item = [MLSEncryptLogFileItem encryptLogFileItemWithFileAttribute:fileAttr atPath:filePath];
	if (item) {
		if (self.decryptLogFileItems) {
			NSMutableArray *array = [NSMutableArray arrayWithArray:self.decryptLogFileItems];
			[array addObject:item];
			self.decryptLogFileItems = array;
		} else {
			self.decryptLogFileItems = @[item];
		}
	}
	return item;
}
@end
