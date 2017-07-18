# MLSEncryptLog
***
一个简单的日志加密和解密工具
使用方法

```
可使用宏定义, MLSLog(...) 替换 NSLog(...) 即可
```

```
MLSEncryptLogShareConfig 用来配置 log 日志信息参数.
MLSEncryptLogManager 解密当前 log 日志系统加密文件解密文件 或者 是指定加密日志文件存在的文件夹的文件

```


*****

##加密测试方法

```
/// 多线程, 并发测试
- (void)testAsyncMutableThread
{
	MLSEncryptLogShareConfig.singleFileMaxLength = 20; // 单个文件最大20KB
	
	dispatch_group_t group = dispatch_group_create();
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	for (int i = 0; i < 100; i++)
	{
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
		dispatch_group_async(group, queue, ^{
			MLSLog(@"%d==2=%@=!@#@%#$%测 **@#$%^&*(试asdg 爱上冷蓝色的老顾客呢忘了是加密啊哈哈哈哈asdg 爱上冷蓝色的老asdg 爱上冷蓝色的老顾客呢忘了顾客呢忘了杜拉拉过呢",i,[NSThread currentThread]);
			MLSLog(@"%d==3=%@=!@#@%#$%测 **@#$%^&*(试asdg 爱上冷蓝色的老顾客呢忘了是加密啊哈哈哈哈asdg 爱上冷蓝色的老asdg 爱上冷蓝色的老顾客呢忘了顾客呢忘了杜拉拉过呢",i,[NSThread currentThread]);
			MLSLog(@"%d==5=%@=!@#@%#$%测 **@#$%^&*(试asdg 爱上冷蓝色的老顾客呢忘了是加密啊哈哈哈哈asdg 爱上冷蓝色的老asdg 爱上冷蓝色的老顾客呢忘了顾客呢忘了杜拉拉过呢",i,[NSThread currentThread]);
			MLSLog(@"%d==4=%@=!@#@%#$%测 **@#$%^&*(试asdg 爱上冷蓝色的老顾客呢忘了是加密啊哈哈哈哈asdg 爱上冷蓝色的老asdg 爱上冷蓝色的老顾客呢忘了顾客呢忘了杜拉拉过呢",i,[NSThread currentThread]);
			MLSLog(@"%d==6=%@=!@#@%#$%测 **@#$%^&*(试asdg 爱上冷蓝色的老顾客呢忘了是加密啊哈哈哈哈asdg 爱上冷蓝色的老asdg 爱上冷蓝色的老顾客呢忘了顾客呢忘了杜拉拉过呢",i,[NSThread currentThread]);
			//			sleep(2);
			dispatch_semaphore_signal(semaphore);
		});
	}
	dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}
```


```
/// 单线程, 测试
- (void)testAsyncSingleThread
{
	MLSEncryptLogShareConfig.singleFileMaxLength = 5; // 单个文件最大5KB
	
	for (int i = 0; i < 100; i++)
	{
		MLSLog(@"%d====!@#@%#$%测 **@#$%^&*(试asdg 爱上冷蓝色的老顾客呢忘了是加密啊哈哈哈哈asdg 爱上冷蓝色的老asdg 爱上冷蓝色的老顾客呢忘了顾客呢忘了杜拉拉过呢",i);
	}
}
```

##解密测试

```
- (void)decryptDir {
	/// 解密指定文件夹下的加密日志
	NSString *logDir = @"";
	[MLSEncryptLogManager getDecryptLogFileItemsFromDir:logDir completion:^(NSArray<MLSEncryptLogFileItem *> *items) {
		for (MLSEncryptLogFileItem *item in items) {
			NSLog(@"item - %@",item.path);
		}
	}];
}

- (void)decryptSystem {
	/// 解密当前系统下的加密日志
	[MLSEncryptLogManager getDecryptLogFileItems:^(NSArray<MLSEncryptLogFileItem *> *items) {
		for (MLSEncryptLogFileItem *item in items) {
			NSLog(@"item - %@",item);
		}
	}];
}
```