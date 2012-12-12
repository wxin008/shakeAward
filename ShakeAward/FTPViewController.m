//
//  FTPViewController.m
//  ShakeAward
//
//  Created by  on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Constant.h"
#import "FTPViewController.h"
#import "SettingAwardViewController.h"
#import "JSON.h"

@interface FTPViewController ()

@end

@implementation FTPViewController
@synthesize ftpUserName;
@synthesize ftpPassword;
@synthesize ftpUrl;
@synthesize ftpBtn;
@synthesize alert;
@synthesize isFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [SocketUtils getInstance:self];
        [self getFtpInfo];
    }
    return self;
}

//获取ftp信息
- (void) getFtpInfo{
    //用户id
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
    //socket请求服务端
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:AWARDFTP_selectAwardFtp forKey:@"requestActs"];//标识抽奖管理员注册
    //该id需要从全局取XXXXXXXX
    [awardDic setValue:userIdStr forKey:@"awardUserId"];
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
    NSLog(@"[getFtp.request.json] :%@",awardJSON);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ftpBtn addTarget:self action:@selector(setFinished) forControlEvents:UIControlEventTouchUpInside];
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
    NSLog(@"Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *msgDic = [message JSONValue];
    NSString *returnCodeStr = [msgDic objectForKey:@"returnCode"];
    NSString *ftpUserNameStr = [msgDic objectForKey:@"ftpUserName"];
    if ([isFlag length]>0 &&[returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        //添加成功
        if ([isFlag isEqualToString:ADD_FLAG]) {
            alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" 
                                               message:@"FTP设置成功！" 
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
        }
        //更新成功
        if ([isFlag isEqualToString:MODIFY_FLAG]) {
            alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" 
                                               message:@"FTP修改成功！" 
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
        }
    }else if([isFlag length]>0 && [returnCodeStr isEqualToString:RETURN_FAILURE]){
        alert = ALERT_MESSAGE(@"提示", @"服务器请求异常");
        [alert show];
    }
    
    if ([ftpUserNameStr length] > 0) {//已存在ftp信息
        isFlag = MODIFY_FLAG;
        ftpUserName.text = ftpUserNameStr;
        NSString *ftpPasswordStr = [msgDic objectForKey:@"ftpPassword"];
        ftpPassword.text = ftpPasswordStr;
        NSString *ftpUrlStr = [msgDic objectForKey:@"ftpUrl"];
        ftpUrl.text = ftpUrlStr;
        ftpBtn.titleLabel.text = @"修改";
    }else{//不存在
        isFlag = ADD_FLAG;
        ftpBtn.titleLabel.text = @"确定";
    }
    
}

//关闭websocket
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
     [SocketUtils releaseInstance];
}

- (void)viewDidUnload
{
    [self setFtpUserName:nil];
    [self setFtpPassword:nil];
    [self setFtpUrl:nil];
    [self setFtpBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setFinished {
    NSString *ftpUserNameStr = ftpUserName.text;
    NSString *ftpPasswordStr = ftpPassword.text;
    NSString *ftpUrlStr = ftpUrl.text;
    if ([ftpUserNameStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"用户名不能为空");
        [alert show];
    }else if ([ftpPasswordStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"密码不能为空");
        [alert show];
    }else if ([ftpUrlStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"地址不能为空");
        [alert show];
    }else {
        //用户id
        NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
        //socket请求服务端
        NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
        if ([isFlag isEqualToString:MODIFY_FLAG]) {//修改
            [awardDic setValue:AWARDFTP_updateWardFtp forKey:@"requestActs"];
        }else if([isFlag isEqualToString:ADD_FLAG]){//添加
            [awardDic setValue:AWARDFTP_addWardFtp forKey:@"requestActs"];
        }
        [awardDic setValue:ftpUserNameStr forKey:@"ftpUserName"];
        [awardDic setValue:ftpPasswordStr forKey:@"ftpPassword"];
        [awardDic setValue:ftpUrlStr forKey:@"ftpUrl"];
        [awardDic setValue:userIdStr forKey:@"awardUserId"];
        NSString *awardJSON = [awardDic JSONRepresentation];
        [[SocketUtils getInstance:self] send:awardJSON];
        NSLog(@"[ftp.request.json] :%@",awardJSON);
        
    }
    
}

- (IBAction)back:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    //级别设置界面
    SettingAwardViewController *settingVC = [[SettingAwardViewController alloc] initWithNibName:@"SettingAwardViewController" bundle:nil];
    [self presentModalViewController:settingVC animated:YES];
}

-(void) hidderAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    //级别设置界面
    SettingAwardViewController *settingVC = [[SettingAwardViewController alloc] initWithNibName:@"SettingAwardViewController" bundle:nil];
    [self presentModalViewController:settingVC animated:YES];
}

#pragma mark TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

@end
