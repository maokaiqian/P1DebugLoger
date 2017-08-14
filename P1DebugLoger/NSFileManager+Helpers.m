//
//  NSFileManager+Helpers.m
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import "NSFileManager+Helpers.h"

@implementation NSFileManager (Helpers)

- (BOOL)createDirectoryIfNeeded:(NSString *)directoryPath {
    if (!directoryPath.length) { return NO; }
    NSError *error = nil;
    if (![self fileExistsAtPath:directoryPath]) {
        [self createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
        if(error) {
            NSLog(@"Failed to create directory (%@): %@", directoryPath, error);
            return NO;
        }
    }
    return YES;
}

@end
