//
//  RegisterViewController.m
//  ShakeAward
//
//  Created by  on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "Constant.h"
#import "LoginViewController.h"
#import "AwardUser.h"
#import "JSON.h"
#import "ViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize companyName;
@synthesize userName;
@synthesize password;
@synthesize email;
@synthesize realName;
@synthesize mainView;
//@synthesize _webSocket;

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
    NSLog(@"Register.Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *msgDic = [message JSONValue];
    NSString *returnCodeStr = [msgDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"注册成功");
        [alert show];
        //请求成功后，跳到登录
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentModalViewController:loginVC animated:YES];
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"注册失败");
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
    [self setCompanyName:nil];
    [self setUserName:nil];
    [self setPassword:nil];
    [self setEmail:nil];
    [self setRealName:nil];
//    [self set_webSocket:nil];
    [self setMainView:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)back:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
}

- (IBAction)registerUser:(id)sender {
    NSString *companyNameStr = companyName.text;
    NSString *realNameStr = realName.text;
    NSString *userNameStr = userName.text;
    NSString *passwordStr = password.text;
    NSString *emailStr = email.text;
    if ([companyNameStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"公司名称不能为空");
        [alert show];
    }else if ([realNameStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"真实姓名不能为空");
        [alert show];
    }else if ([userNameStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"用户名不能为空");
        [alert show];
    }else if ([passwordStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"密码不能为空");
        [alert show];
    }else if ([emailStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"邮箱不能为空");
        [alert show];
    }else {
        //请求服务端
        NSMutableDictionary *awardUserdic = [[NSMutableDictionary alloc] init];
        [awardUserdic setValue:AWARDUSER_registerUser forKey:@"requestActs"];//标识抽奖管理员注册
        [awardUserdic setValue:companyNameStr forKey:@"company"];
        [awardUserdic setValue:realNameStr forKey:@"realName"];
        [awardUserdic setValue:userNameStr forKey:@"userName"];
        [awardUserdic setValue:passwordStr forKey:@"password"];
        [awardUserdic setValue:emailStr forKey:@"email"];
        NSString *awardUserJSON = [awardUserdic JSONRepresentation];
//        [_webSocket send:awardUserJSON];
        [[SocketUtils getInstance:self] send:awardUserJSON];
        NSLog(@"[register.json] :%@",awardUserJSON);
    }
}

#pragma mark TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    mainView.frame = CGRectMake(0, 50, 320, 367);
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (textField == email) {
        mainView.frame = CGRectMake(0, -20, 320, 367);
    }
    [UIView commitAnimations];
}


@end
