//
//  UsersViewController.h
//  ShakeAward
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberShakeAwardViewController.h"
//#import "SRWebSocket.h"
#import "JSON.h"
#import "Constant.h"
#import "SocketUtils.h"

@interface UsersViewController : UIViewController<SRWebSocketDelegate,UITextFieldDelegate>
//抽奖管理员ID
@property (weak, nonatomic) IBOutlet UITextField *managerNo;
//用户抽奖号码
@property (weak, nonatomic) IBOutlet UITextField *awardNo;
//公司名称
@property (weak, nonatomic) IBOutlet UITextField *companyName;
//真实姓名
@property (weak, nonatomic) IBOutlet UITextField *realName;
//部门
@property (weak, nonatomic) IBOutlet UITextField *department;
//用户名
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIView *main_view;

//@property (strong,nonatomic) SRWebSocket *_webSocket;
@property (strong,nonatomic) UIAlertView *alert;

- (IBAction)saveAwardNo:(id)sender;
- (IBAction)back:(id)sender;

@end
