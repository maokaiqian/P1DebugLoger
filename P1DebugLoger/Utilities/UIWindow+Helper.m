//
//  UIWindow+Helper.m
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import "UIWindow+Helper.h"

@implementation UIWindow (Helper)

- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow visibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)visibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow visibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow visibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    } else if (vc.presentedViewController) {
        return [UIWindow visibleViewControllerFrom:vc.presentedViewController];
    } else {
        return vc;
    }
}
@end
