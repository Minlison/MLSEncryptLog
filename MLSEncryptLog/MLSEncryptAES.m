//
//  MLSEncryptAES.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "MLSEncryptAES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define __PASSWORD_KEY__      @"CqtR3yEzODSvFek0BGJaxw=="
#define __IV_KEY__            @"0102030405060708"

@implementation MLSEncryptAES
+ (NSData *)encryptData:(NSData *)data
{
	return [self aes256EncryptData:data WithKey:[self getKey] iv:[self getIV]];
}

+ (NSData *)decryptData:(NSData *)data
{
	return [self aes256DecryptData:data Withkey:[self getKey] iv:[self getIV]];
}




+ (NSData *)getKey
{
	return [[NSData alloc] initWithBase64EncodedString:__PASSWORD_KEY__ options:0];
}

+ (NSData *)getIV
{
	return [__IV_KEY__ dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)aes256EncryptData:(NSData *)data WithKey:(NSData *)key iv:(NSData *)iv {
	if (key.length != 16 && key.length != 24 && key.length != 32) {
		return nil;
	}
	if (iv.length != 16 && iv.length != 0) {
		return nil;
	}
	
	NSData *result = nil;
	size_t bufferSize = data.length + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	if (!buffer) return nil;
	size_t encryptedSize = 0;
	
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
					      kCCAlgorithmAES128,
					      kCCOptionPKCS7Padding | kCCOptionECBMode,
					      key.bytes,
					      key.length,
					      iv.bytes,
					      data.bytes,
					      data.length,
					      buffer,
					      bufferSize,
					      &encryptedSize);
	if (cryptStatus == kCCSuccess) {
		result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
		
		free(buffer);
		return result;
	} else {
		free(buffer);
		return nil;
	}
}

+ (NSData *)aes256DecryptData:(NSData *)data Withkey:(NSData *)key iv:(NSData *)iv {
	if (key.length != 16 && key.length != 24 && key.length != 32) {
		return nil;
	}
	if (iv.length != 16 && iv.length != 0) {
		return nil;
	}
	
	NSData *result = nil;
	size_t bufferSize = data.length + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	if (!buffer) return nil;
	size_t encryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
					      kCCAlgorithmAES128,
					      kCCOptionPKCS7Padding | kCCOptionECBMode,
					      key.bytes,
					      key.length,
					      iv.bytes,
					      data.bytes,
					      data.length,
					      buffer,
					      bufferSize,
					      &encryptedSize);
	if (cryptStatus == kCCSuccess) {
		result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
		free(buffer);
		return result;
	} else {
		free(buffer);
		return nil;
	}
}
@end
