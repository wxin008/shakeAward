//
//  LoginViewController.m
//  ShakeAward
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Constant.h"
#import "RegisterViewController.h"
#import "SettingAwardViewController.h"
#import "JSON.h"
#import "ViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userName;
@synthesize password;
//@synthesize _webSocket;
@synthesize alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [SocketUtils getInstance:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Socket
//    _webSocket.delegate = nil;
//    [_webSocket close];
//    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_SERVER]]];
//    _webSocket.delegate = self;
//    [_webSocket open];
//    NSLog(@"Socket open.");
    
}

#pragma mark - SRWebSocketDelegate
//连接websocket
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    
}

//websocket错误
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
//    _webSocket = nil;
    [SocketUtils releaseInstance];
}

//接收数据
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Login.Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *loginDic = [message JSONValue];
    //保存用户id
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"id"] forKey:@"USER_ID"];
    //保存用户名
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"userName"] forKey:@"USER_NAME"];
    //保存用户密码
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"password"] forKey:@"USER_PASSWORD"];
    //保存用户登录状态
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"state"] forKey:@"USER_STATE"];
    //保存公司名称
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"company"] forKey:@"USER_COMPANY"];
    NSString *returnCodeStr = [loginDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" 
                                           message:@"登录成功！" 
                                          delegate:self 
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self 
                                       selector:@selector(hidderAlert)
                                       userInfo:@"正在更新数据"
                                        repeats:NO];
        //级别设置界面
        SettingAwardViewController *settingVC = [[SettingAwardViewController alloc] initWithNibName:@"SettingAwardViewController" bundle:nil];
        [self presentModalViewController:settingVC animated:YES];
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        alert = ALERT_MESSAGE(@"提示", @"登录异常");
        [alert show];
    }
}

//关闭websocket
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
//    _webSocket = nil;
    [SocketUtils releaseInstance];
}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setPassword:nil];
//    [self set_webSocket:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)login:(id)sender {
    NSString *userNameStr = userName.text;
    NSString *passwordStr = password.text;
    if ([userNameStr length] == 0) {
         alert = ALERT_MESSAGE(@"提示", @"用户名不能为空");
        [alert show];
    }else if ([passwordStr length] == 0) {
         alert = ALERT_MESSAGE(@"提示", @"密码不能为空");
        [alert show];
    }else {
        //socket请求服务端
        NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
        [awardDic setValue:AWARDUSER_loginUser forKey:@"requestActs"];//标识抽奖管理员注册
        [awardDic setValue:userNameStr forKey:@"userName"];
        [awardDic setValue:passwordStr forKey:@"password"];
        NSString *awardJSON = [awardDic JSONRepresentation];
//         [_webSocket send:awardJSON];
        [[SocketUtils getInstance:self] send:awardJSON];
         NSLog(@"登录请求json: %@",awardJSON);
        //请求成功后，进入抽奖设置大厅(XXXX如果已设置过抽奖级别，是否直接进入抽奖大厅，否则进入抽奖设置大厅)
    }
}

- (IBAction)back:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
}

- (IBAction)registerUser:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self presentModalViewController:registerVC animated:YES];
}

-(void) hidderAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

@end
