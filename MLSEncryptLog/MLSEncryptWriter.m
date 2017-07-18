//
//  MLSEncryptWriter.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptWriter.h"
#import "MLSEncryptFileManager.h"
#import "MLSEncryptLogConfig.h"
#import "MLSEncryptLogEncrypt.h"
#define MLSEncryptShareWriter [MLSEncryptWriter sharedInstance]
@interface MLSEncryptWriter()
@end

@implementation MLSEncryptWriter
+ (instancetype)sharedInstance {
	static dispatch_once_t MLSEncryptWriteronceToken;
	static MLSEncryptWriter *instance = nil;
	dispatch_once(&MLSEncryptWriteronceToken,^{
		instance = [[MLSEncryptWriter alloc] init];
	});
	return instance;
}
- (MLSEncryptFileStreamType)streamType
{
	return MLSEncryptFileStreamTypeWrite;
}

+ (void)writeData:(NSData *)data
{
	[MLSEncryptShareWriter writeData:data];
}

- (void)writeData:(NSData *)data
{
	dispatch_async(MLSEncryptLogShareConfig.log_queue, ^{
		[self findCurrentAvailabileItem];
		if (!data || !self.fileItem)
		{
			return;
		}
		if ([self.fileItem writeData:[MLSEncryptLogEncrypt encryptData:data]])
		{
			NSLog(@"write data %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
		}
	});
}

+ (void)writeString:(NSString *)string
{
	if (!string)
	{
		return;
	}
	[self writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
	
}
@end
