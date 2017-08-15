//
//  SendEmailHandler.m
//  P1DebugLoger
//
//  Created by maokaiqian on 2017/8/14.
//  Copyright © 2017年 maokaiqian. All rights reserved.
//

#import "SendEmailHandler.h"
#import "P1DiagnoseLogger.h"
#import <MessageUI/MessageUI.h>
#import "SSZipArchive.h"
#import "UIViewController+Helpers.h"

@interface SendEmailHandler ()<MFMailComposeViewControllerDelegate>

@end

@implementation SendEmailHandler

+ (instancetype)sharedHandler {
    static dispatch_once_t onceToken;
    static SendEmailHandler *handler = nil;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [[UIViewController topViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendEmailWithPath:(NSString *)filePath {
#if (TARGET_IPHONE_SIMULATOR)
    NSLog(@"不支持模拟器发送邮件");
#else
    //判断用户是否已设置邮件账户
    if (![MFMailComposeViewController canSendMail]) {
        //TODO 如果用户之前没有配置过,不能发送,需要给出提示,告诉用户设备未开启邮件服务
        return;
    }
    if (filePath.length == 0) {
        return;
    }
    NSString *zipPath = [NSString stringWithFormat:@"%@log.zip",
                         NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]];
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withContentsOfDirectory:filePath];
    if (success) {
        // 创建邮件发送界面
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        // 设置邮件代理
        [mailCompose setMailComposeDelegate:self];
        // 设置收件人
        [mailCompose setToRecipients:@[@"maokaiqian@p1.com"]];
        // 设置抄送人
        [mailCompose setCcRecipients:@[@"maomecat@126.com"]];
        // 设置密送人
        [mailCompose setBccRecipients:@[@"1152234104@qq.com"]];
        // 设置邮件主题
        [mailCompose setSubject:@"我是邮件主题"];
        //设置邮件的正文内容
        [mailCompose setMessageBody:@"我是邮件内容" isHTML:NO];
        //添加附件
        NSData *zipData = [NSData dataWithContentsOfFile:zipPath];
        [mailCompose addAttachmentData:zipData mimeType:@"application/zip" fileName:@"log.zip"];
        // 弹出邮件发送视图
        [[UIViewController topViewController] presentViewController:mailCompose animated:YES completion:nil];
    }
#endif
}

@end
