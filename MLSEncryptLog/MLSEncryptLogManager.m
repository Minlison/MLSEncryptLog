//
//  MLSEncryptLogManager.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptLogManager.h"
#import "MLSEncryptLogConfig.h"
#import "MLSEncryptWriter.h"
#import "MLSEncryptReader.h"
#import "MLSEncryptFileManager.h"

@interface MLSEncryptLogManager()

@end
@implementation MLSEncryptLogManager

+ (void)logString:(NSString *)string
{
	[MLSEncryptWriter writeString:string];
}
+ (void)getDecryptLogFileItems:(void (^)(NSArray <MLSEncryptLogFileItem *> *items))completion
{
	dispatch_async(MLSEncryptLogShareConfig.read_queue, ^{
		NSArray<MLSEncryptLogFileItem *> *items = [MLSEncryptReader decrypt];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (completion) {
				completion(items);
			}
		});
	});
}
+ (void)getDecryptLogFileItemsFromDir:(NSString *)logDir completion:(void (^)(NSArray <MLSEncryptLogFileItem *> *items))completion
{
	dispatch_async(MLSEncryptLogShareConfig.read_queue, ^{
		NSArray<MLSEncryptLogFileItem *> *items = [MLSEncryptReader decryptInDir:logDir];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (completion) {
				completion(items);
			}
		});
	});
}
@end



static inline NSString *FromatDateToString(NSString *str)
{
	NSDate *now = [NSDate date];
	static dispatch_once_t onceToken;
	static NSDateFormatter *formatter;
	dispatch_once(&onceToken, ^{
		formatter = [NSDateFormatter new];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	});
	NSString *dateString = [formatter stringFromDate:now];
	return [@"[ MLSEncryptLog ] " stringByAppendingFormat:@"[%@]  %@",dateString,str];
}

void MLSEncryptLog(NSString *format, ...)
{
	if (!format)
	{
		return;
	}
	va_list args, args_copy;
	va_start(args, format);
	va_copy(args_copy, args);
	va_end(args);
	NSString *logText = [[NSString alloc] initWithFormat:format arguments:args_copy];
	va_end(args_copy);
	
	BOOL canUse = YES;
	if ( MLSEncryptLogShareConfig.logFilter )
	{
		canUse = MLSEncryptLogShareConfig.logFilter(logText);
	}
	if ( canUse )
	{
		[MLSEncryptLogManager logString:[NSString stringWithFormat:@"%@\n",logText]];
		if (MLSEncryptLogShareConfig.consoleEnable) {
			printf("%s\n",[FromatDateToString(logText) cStringUsingEncoding:NSUTF8StringEncoding]);
		}
	}
	
	if (canUse)
	{
		
	}
	
}
