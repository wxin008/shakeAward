//
//  RegisterViewController.h
//  ShakeAward
//  管理人注册
//  Created by Dwen on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SRWebSocket.h"
#import "SocketUtils.h"

@interface RegisterViewController : UIViewController<SRWebSocketDelegate,UITextFieldDelegate>
//公司名称
@property (weak, nonatomic) IBOutlet UITextField *companyName;
//用户名称
@property (weak, nonatomic) IBOutlet UITextField *userName;
//密码
@property (weak, nonatomic) IBOutlet UITextField *password;
//邮箱
@property (weak, nonatomic) IBOutlet UITextField *email;
//真实姓名
@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UIView *mainView;

//@property (strong,nonatomic) SRWebSocket *_webSocket;

//注册
- (IBAction)registerUser:(id)sender;
//返回
- (IBAction)back:(id)sender;

@end
