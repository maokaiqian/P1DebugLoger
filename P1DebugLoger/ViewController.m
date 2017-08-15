//
//  ViewController.m
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import "ViewController.h"
#import "P1DiagnoseLogger.h"

#define kTestText   @"All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved.Copyright © 2017年 maokaiqian. All rights reserved."

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:btn];
    [btn setTitle:@"写log" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 100, 100)];
    [self.view addSubview:btn2];
    [btn2 setTitle:@"发送邮件" forState:(UIControlStateNormal)];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 addTarget:self action:@selector(btnClick2:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)btnClick1:(UIButton *)button {
    [[P1DiagnoseLogger sharedLogger] doLog:kTestText];
}

- (void)btnClick2:(UIButton *)button {
    [[P1DiagnoseLogger sharedLogger] doArchive:nil];
}

@end
