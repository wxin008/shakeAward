//
//  FTPViewController.h
//  ShakeAward
//  ftp服务器设置
//  Created by Dwen on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketUtils.h"

@interface FTPViewController : UIViewController<SRWebSocketDelegate,UITextFieldDelegate>
//ftp用户名
@property (weak, nonatomic) IBOutlet UITextField *ftpUserName;
//ftp密码
@property (weak, nonatomic) IBOutlet UITextField *ftpPassword;
//ftp服务器url
@property (weak, nonatomic) IBOutlet UITextField *ftpUrl;
@property (weak, nonatomic) IBOutlet UIButton *ftpBtn;

@property (strong,nonatomic) UIAlertView *alert;
//ftp添加和修改标识
@property (strong,nonatomic) NSString *isFlag;

//ftp设置完成
- (void)setFinished;
//返回
- (IBAction)back:(id)sender;

@end
