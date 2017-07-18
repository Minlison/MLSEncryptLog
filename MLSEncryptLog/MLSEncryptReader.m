//
//  MLSEncryptReader.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptReader.h"
#import "MLSEncryptLogEncrypt.h"
#import "MLSEncryptFileManager.h"
#import "MLSEncryptAES.h"
#import "MLSEnryptHelper.h"

#define MLSEncryptShareReader [MLSEncryptReader sharedInstance]
@implementation MLSEncryptReader
+ (instancetype)sharedInstance {
	static dispatch_once_t MLSEncryptReaderonceToken;
	static MLSEncryptReader *instance = nil;
	dispatch_once(&MLSEncryptReaderonceToken,^{
		instance = [[MLSEncryptReader alloc] init];
	});
	return instance;
}

- (MLSEncryptFileStreamType)streamType
{
	return MLSEncryptFileStreamTypeRead;
}
+ (NSArray <MLSEncryptLogFileItem *> *)decrypt
{
	return [MLSEncryptShareReader decrypt];
}
+ (NSArray <MLSEncryptLogFileItem *> *)decryptInDir:(NSString *)logdir
{
	if ( ![MLSEnryptHelper dirIsExistAtPath:logdir] ) {
		return [MLSEncryptShareReader decrypt];
	}
	return [MLSEncryptShareReader decryptInDir:logdir];
}
- (NSArray <MLSEncryptLogFileItem *> *)decryptInDir:(NSString *)logdir
{
	[MLSEncryptFileManagerShareInstance setLogDirectory:logdir autoCreate:NO];
	return [self decrypt];
}
- (NSArray <MLSEncryptLogFileItem *> *)decrypt
{
	[self recursiveDecrypt];
	return MLSEncryptFileManagerShareInstance.decryptLogFileItems;
}
- (void)recursiveDecrypt
{
	@synchronized (self) {
		if ( [self findCurrentAvailabileItem] )
		{
			/// 递归解密文件
			MLSEncryptLogFileItem *item = [MLSEncryptFileManagerShareInstance createDecryptLogFileFor:self.fileItem error:nil];
			
			if ( item )
			{
				[item openFileWithType:(MLSEncryptLogFileItemTypeWrite)];
				if ( [MLSEncryptLogEncrypt startDecryptFileItem:self.fileItem error:nil] )
				{
					NSData *readData = nil;
					while ( (readData =[MLSEncryptLogEncrypt decryptOnce:self.fileItem]) )
					{
						[item writeData:readData];
					}
					[MLSEncryptLogEncrypt endDecryptFileItem:self.fileItem];
				}
				[item close];
				[self recursiveDecrypt];
			}
		}
	}
}

@end
