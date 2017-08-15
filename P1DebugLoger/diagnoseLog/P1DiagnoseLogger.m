//
//  P1DebugLogger.m
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import "P1DiagnoseLogger.h"
#import "NSFileManager+Helpers.h"

static NSString * LogDirectory = @"DebugLogger";
static NSString * LogFileBaseName = @"log";

@interface P1DiagnoseLogger ()

@property (nonatomic, assign) NSInteger maxGenerationLevel;
@property (nonatomic, assign) NSInteger maxFileSize;
@property (nonatomic, readwrite) NSURL *logPath;
@property (nonatomic, strong) dispatch_queue_t logQueue;

@end

@implementation P1DiagnoseLogger

+ (instancetype)sharedLogger {
    static P1DiagnoseLogger * logger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [[P1DiagnoseLogger alloc] init];
    });
    
    return logger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _logQueue = dispatch_queue_create("DebugLoggerQueue", NULL);
        _maxGenerationLevel = 8;
        //TODO 为了测试方便,先改为1k
        _maxFileSize = 1024;//512 * 1024; // 512k
        [self setLogPath];
    }
    
    return self;
}

- (void)setLogPath {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *directoryURL = [documentsURL URLByAppendingPathComponent:LogDirectory isDirectory:YES];
    
    [[NSFileManager defaultManager] createDirectoryIfNeeded:[directoryURL path]];
    NSURL *logFile = [directoryURL URLByAppendingPathComponent:LogFileBaseName];
    _logPath = logFile;
    NSLog(@"_logPath: %@", _logPath);
}

- (void)setMaxGeneration:(NSInteger)maxGeneration {
    _maxGenerationLevel = maxGeneration;
}

- (void)doLog:(NSString *)message {
    dispatch_async(_logQueue, ^{
        // Check the file size.
        NSError *error = nil;
        NSNumber *fileSize = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:[self writableLogFilePath]]) {
            
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self writableLogFilePath] error:&error];
            if (!error && attributes && [attributes objectForKey:NSFileSize]) {
                
                fileSize = [attributes objectForKey:NSFileSize];
                if ([fileSize unsignedLongLongValue] > _maxFileSize) {
                    //页面下移
                    NSString *currentGenerationFile = nil;
                    NSString *nextGenerationFile = nil;
                    NSInteger currentGeneration = _maxGenerationLevel;
                    
                    currentGeneration--;
                    while (currentGeneration >= 0) {
                        currentGenerationFile = [self logFilePathAtGeneration:currentGeneration];
                        nextGenerationFile = [self logFilePathAtGeneration:(currentGeneration + 1)];
                        
                        if ([fileManager fileExistsAtPath:nextGenerationFile]) {
                            // delete the next generation log file.
                            [fileManager removeItemAtPath:nextGenerationFile error:&error];
                        }
                        
                        [fileManager moveItemAtPath:currentGenerationFile toPath:nextGenerationFile error:&error];
                        if (error) {
                            NSLog(@"moveItemAtPath:toPath:error: error is: %@", error);
                        }
                        currentGeneration--;
                    }
                }
                
                // Write the message to writable log file.
                NSString *newMessage = [NSString stringWithFormat:@"%@\n", message];
                [self writeMessage:newMessage toFile:[self writableLogFilePath]];
                
            } else {
                NSLog(@"attributesOfItemAtPath:error: error is:%@", error);
                
            }
        }
        else {
            // Write the message to writable log file.
            NSString *newMessage = [NSString stringWithFormat:@"%@\n", message];
            [self writeMessage:newMessage toFile:[self writableLogFilePath]];
        }
    });
}

- (void)doArchive:(void (^) (NSArray * filePaths))completionBlock {
    dispatch_async(_logQueue, ^{
        NSError *error = nil;
        NSUUID *uuid = [NSUUID UUID];
        NSString *uuidString = [uuid UUIDString];
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *directoryURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",LogDirectory,uuidString] isDirectory:YES];
        NSString *archiveDirectory = directoryURL.path;
        [[NSFileManager defaultManager] createDirectoryAtPath:archiveDirectory withIntermediateDirectories:NO attributes:nil error:&error];
        
        NSInteger currentGeneration = _maxGenerationLevel;
        while (currentGeneration >= 0) {
            NSString *fromPath = [self logFilePathAtGeneration:currentGeneration];
            NSString *toPath = [archiveDirectory stringByAppendingFormat:@"/log.%ld", (long)currentGeneration];
            [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error];
            currentGeneration--;
        }

        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(@[archiveDirectory]);
            });
        }
    });
}

#pragma mark - Private Methods
- (NSString *)writableLogFilePath {
    return [self logFilePathAtGeneration:0];
}

- (NSString *)logFilePathAtGeneration:(NSInteger)generation {
    return [[_logPath path] stringByAppendingFormat:@".%ld", (long)generation];
}

- (void)writeMessage:(NSString *)message toFile:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        // Create this file 'path' if needed.
        NSError *error = nil;
        [message writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"[%@] Error: %@", NSStringFromSelector(_cmd), error);
        }
    }
    else {
        // Open file 'path' and write the 'message' to it.
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
        [myHandle synchronizeFile];
        [myHandle closeFile];
    }
}

@end
