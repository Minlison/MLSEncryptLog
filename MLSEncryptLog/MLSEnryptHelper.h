//
//  MLSEnryptDateHelper.h
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLSEnryptHelper : NSObject

/**
 当前时间字符串
 默认 @"yyyy_MM_dd_HH_mm_ss"

 @return 字符串
 */
+ (NSString *)currentTimeString;

/**
 时间字符串

 @param format 格式化时间
 @return 字符串
 */
+ (NSString *)currentTimeStringWithFormat:(NSString *)format;

/**
 时间字符串

 @param date 日期
 @param format 格式化
 @return 字符串
 */
+ (NSString *)timeStringForDate:(NSDate *)date withFormat:(NSString *)format;


+ (BOOL)dirIsExistAtPath:(NSString *)path;
+ (BOOL)fileIsExistAtPath:(NSString *)path;
+ (BOOL)removeFileAtPath:(NSString *)path;
+ (BOOL)trashFileAtPath:(NSString *)path;
+ (BOOL)removeFloderAtPath:(NSString *)path;
@end
