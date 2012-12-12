//
//  LoginViewController.h
//  ShakeAward
//  抽奖人登录界面
//  Created by Dwen  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SRWebSocket.h"
#import "SocketUtils.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,SRWebSocketDelegate>
//用户名
@property (weak, nonatomic) IBOutlet UITextField *userName;
//密码
@property (weak, nonatomic) IBOutlet UITextField *password;

//@property (strong,nonatomic) SRWebSocket *_webSocket;
@property (strong,nonatomic) UIAlertView *alert;

//用户登录
- (IBAction)login:(id)sender;
//返回
- (IBAction)back:(id)sender;
//用户注册
- (IBAction)registerUser:(id)sender;

@end
