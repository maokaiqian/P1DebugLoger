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

@interface P1DebugLogger : NSObject

@property (nonatomic, readonly) NSURL *logPath;

+ (instancetype)sharedLogger;

- (void)doLog:(NSString *)message;

- (void)doArchive:(void (^) (NSArray * filePaths))completionBlock;

@end
