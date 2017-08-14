//
//  NSFileManager+Helpers.h
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Helpers)

- (BOOL)createDirectoryIfNeeded:(NSString *)directoryPath;
@end
