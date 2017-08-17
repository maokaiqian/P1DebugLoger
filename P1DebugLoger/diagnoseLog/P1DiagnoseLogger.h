//
//  P1DebugLogger.h
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifdef DEBUG

#define XDebugLog(format, ...) do { \
NSString* message = [NSString stringWithFormat:format, ##__VA_ARGS__]; \
[[P1DebugLogger sharedLogger] doLog:message]; \
} while(0)

//#else
//#define XDebugLog(format, ...) ({})
//#endif

@interface P1DiagnoseLogger : NSObject

@property (nonatomic, readonly) NSURL *logPath;

+ (instancetype)sharedLogger;

/**
 写入需要记录的信息

 @param message 写入的信息
 */
- (void)doLog:(NSString *)message;

/**
 将记录的信息打包并邮件发送

 @param completionBlock 打包完成后的回调
 */
- (void)doArchive:(void (^) (NSArray * filePaths))completionBlock;

@end
