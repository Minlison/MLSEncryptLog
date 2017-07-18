//
//  MLSEnryptDateHelper.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEnryptHelper.h"

@implementation MLSEnryptHelper
+ (NSString *)currentTimeString
{
	NSDate *date = [NSDate date];
	NSString *formatString = [self timeStringForDate:date withFormat:@"yyyy_MM_dd_HH_mm_ss_SSS"];
	return [NSString stringWithFormat:@"%@_%lld",formatString,(long long)([date timeIntervalSince1970] * 1000000)];
}
+ (NSString *)currentTimeStringWithFormat:(NSString *)format
{
	return [self timeStringForDate:[NSDate date] withFormat:format];
}
+ (NSString *)timeStringForDate:(NSDate *)date withFormat:(NSString *)format
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = format;
	formatter.timeZone = [NSTimeZone localTimeZone];
	return [formatter stringFromDate:date];
}


+ (BOOL)dirIsExistAtPath:(NSString *)path
{
	if (!path) {
		return NO;
	}
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL isDir = NO;
	BOOL exist = [manager fileExistsAtPath:path isDirectory:&isDir];
	
	return (exist && isDir);
	
}
+ (BOOL)fileIsExistAtPath:(NSString *)path
{
	if (!path) {
		return NO;
	}
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL isDir = NO;
	BOOL exist = [manager fileExistsAtPath:path isDirectory:&isDir];
	
	return (exist && !isDir);
}
+ (BOOL)removeFileAtPath:(NSString *)path
{
	if (!path) {
		return NO;
	}
	NSFileManager *manager = [NSFileManager defaultManager];
	return [manager removeItemAtPath:path error:nil];
}
+ (BOOL)trashFileAtPath:(NSString *)path
{
	if (!path) {
		return NO;
	}
	NSFileManager *manager = [NSFileManager defaultManager];
	return [manager trashItemAtURL:[NSURL fileURLWithPath:path] resultingItemURL:nil error:nil];
}
+ (BOOL)removeFloderAtPath:(NSString *)path
{
	if (!path) {
		return NO;
	}
	NSFileManager *manager = [NSFileManager defaultManager];
	return [manager removeItemAtPath:path error:nil];
}
@end
