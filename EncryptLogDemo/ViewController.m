//
//  ViewController.m
//  EncryptLogDemo
//
//  Created by MinLison on 2017/7/14.
//  Copyright © 2017年 minlison. All rights reserved.
//

#import "ViewController.h"
#import "MLSEncryptLog.h"
#import "MLSEncryptLogManager.h"

#define __APPDELEGATE__  ((AppDelegate *)[NSApplication sharedApplication].delegate)

@interface ViewController()
@property (weak) IBOutlet NSTextField *textFiled;
@property (weak) IBOutlet NSButton *choseButton;

@end
@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	[self testAsyncSingleThread];
	
//	[self testAsyncMutableThread];

	
}
- (IBAction)choseDecryptFile:(id)sender
{
	
	[self showPathOpenPanelCanChoseFiles:NO canChoseDir:YES allowMutipleSelection:NO directoryURL:nil contentTypes:nil completion:^(NSArray<NSURL *> *urls) {
		self.textFiled.stringValue = urls.lastObject.absoluteString;
	}];
}
- (void)showPathOpenPanelCanChoseFiles:(BOOL)canChoseFiles canChoseDir:(BOOL)canChoseDir allowMutipleSelection:(BOOL)mutiable directoryURL:(NSURL *)directoryURL contentTypes:(NSArray <NSString *>*)contentTypes completion:(void(^)(NSArray<NSURL *>*urls))completion
{
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection:mutiable];
	[panel setCanChooseDirectories:canChoseDir];
	[panel setCanChooseFiles:canChoseFiles];
	[panel setResolvesAliases:YES];
	panel.allowedFileTypes = contentTypes;
	panel.directoryURL = directoryURL;
	panel.treatsFilePackagesAsDirectories = YES;
	panel.canCreateDirectories = YES;
	
	NSString *panelTitle = NSLocalizedString(@"Choose a file", @"Title for the open panel");
	[panel setTitle:panelTitle];
	
	NSString *promptString = NSLocalizedString(@"Choose", @"Prompt for the open panel prompt");
	[panel setPrompt:promptString];
	
	
	[panel beginWithCompletionHandler:^(NSInteger result) {
		
		// If the return code wasn't OK, don't do anything.
		if (result != NSModalResponseOK)
		{
			return;
		}
		if (completion != nil)
		{
			completion([panel URLs]);
		}
	}];
}
- (IBAction)decrypt:(id)sender {
	/// 解密指定文件夹下的加密日志
	NSString *logDir = @"";
	[MLSEncryptLogManager getDecryptLogFileItemsFromDir:logDir completion:^(NSArray<MLSEncryptLogFileItem *> *items) {
		for (MLSEncryptLogFileItem *item in items) {
			NSLog(@"item - %@",item.path);
		}
	}];
	/// 解密当前系统下的加密日志
	[MLSEncryptLogManager getDecryptLogFileItems:^(NSArray<MLSEncryptLogFileItem *> *items) {
		for (MLSEncryptLogFileItem *item in items) {
			NSLog(@"item - %@",item);
		}
	}];
}

/// 单线程, 测试
- (void)testAsyncSingleThread
{
	MLSEncryptLogShareConfig.singleFileMaxLength = 5; // 单个文件最大5KB
	
	for (int i = 0; i < 100; i++)
	{
		MLSLog(@"%d====!@#@%#$%测 **@#$%^&*(试asdg 爱上冷蓝色的老顾客呢忘了是加密啊哈哈哈哈asdg 爱上冷蓝色的老asdg 爱上冷蓝色的老顾客呢忘了顾客呢忘了杜拉拉过呢",i);
	}
}

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

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
