//
//  UIViewController+Helpers.m
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import "UIViewController+Helpers.h"
#import "UIWindow+Helper.h"

@implementation UIViewController (Helpers)
+ (UIViewController *)topViewController {
    UIViewController *topVC = [[UIApplication sharedApplication].keyWindow visibleViewController];
    return topVC;
}

@end
