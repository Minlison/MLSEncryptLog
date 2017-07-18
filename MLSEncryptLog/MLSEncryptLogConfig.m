//
//  MLSEncryptLogConfig.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptLogConfig.h"
#import "MLSEncryptLogConfig.h"
#import "MLSEncryptFileManager.h"

@interface MLSEncryptLogConfig()
@property (strong, nonatomic, readwrite) dispatch_queue_t log_queue;
@property (strong, nonatomic, readwrite) dispatch_queue_t read_queue;
@end

@implementation MLSEncryptLogConfig
+ (instancetype)shareConfig
{
	static dispatch_once_t MLSEncryptLogConfigonceToken;
	static MLSEncryptLogConfig *instance;
	dispatch_once(&MLSEncryptLogConfigonceToken, ^{
		instance = [[MLSEncryptLogConfig alloc] init];
		[instance _InitDefault];
	});
	return instance;
}
- (void)_InitDefault
{
	_encrypt = YES;
	_consoleEnable = NO;
	_fileType = @"mlslog";
	_singleFileMaxLength = 10240; // 10 MB
	NSString *logDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"mslog"];
	NSString *decryptLogDir = [logDir stringByAppendingPathComponent:@"decrypt"];
	_logDirectory = logDir;
	_decryptDirectory = decryptLogDir;
	_log_queue = dispatch_queue_create("mls_log_queue", DISPATCH_QUEUE_SERIAL);
	_read_queue = dispatch_queue_create("mls_log_read_queue", DISPATCH_QUEUE_SERIAL);
}
- (void)setLogDirectory:(NSString *)logDirectory
{
	_logDirectory = logDirectory.copy;
	[MLSEncryptFileManagerShareInstance setLogDirectory:logDirectory autoCreate:YES];
}
- (void)setDecryptDirectory:(NSString *)decryptDirectory
{
	_decryptDirectory = decryptDirectory;
	[MLSEncryptFileManagerShareInstance setDecryptLogDirectory:decryptDirectory autoCreate:YES];
}
@end
