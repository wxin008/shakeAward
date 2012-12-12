//
//  SettingAwardViewController.m
//  ShakeAward
//
//  Created by  on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingAwardViewController.h"
#import "ShowAwardGradeViewController.h"
#import "FTPViewController.h"
#import "UploadImgViewController.h"
#import "ShakeAwardViewController.h"
#import "ViewController.h"

@interface SettingAwardViewController ()

@end

@implementation SettingAwardViewController
@synthesize awardGradeLab;
@synthesize ftpLab;
@synthesize ftpUploadLab;
@synthesize alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setAwardGradeLab:nil];
    [self setFtpLab:nil];
    [self setFtpUploadLab:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)setAwardGrade:(id)sender {
    ShowAwardGradeViewController *showAwardGradeVC = [[ShowAwardGradeViewController alloc] initWithNibName:@"ShowAwardGradeViewController" bundle:nil];
    [self presentModalViewController:showAwardGradeVC animated:YES];
}

- (IBAction)setFTPParams:(id)sender {
    FTPViewController *ftpVC = [[FTPViewController alloc] initWithNibName:@"FTPViewController" bundle:nil];
    [self presentModalViewController:ftpVC animated:YES];
}

- (IBAction)uploadFTP:(id)sender {
    UploadImgViewController *uploadImgVC = [[UploadImgViewController alloc] initWithNibName:@"UploadImgViewController" bundle:nil];
    [self presentModalViewController:uploadImgVC animated:YES];
}

- (IBAction)setFinished:(id)sender {
    //所有设置先保存到字典中，点击完成时一同提交到服务器
    //.....
    //保存成功后，进入到抽奖大厅
    ShakeAwardViewController *shakeAwardVC = [[ShakeAwardViewController alloc] initWithNibName:@"ShakeAwardViewController" bundle:nil];
    [self presentModalViewController:shakeAwardVC animated:YES];
    
}

- (IBAction)back:(id)sender {
    ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
}

- (IBAction)logout:(id)sender {
    //socket请求服务端
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:AWARD_logout forKey:@"requestActs"];      
    [awardDic setValue:ROLE_USER forKey:@"role"];
    NSString *userId =[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
    [awardDic setValue:userId forKey:@"id"];
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
    NSLog(@"[抽奖人登出].json : %@",awardJSON);
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
    [SocketUtils releaseInstance];
}

//接收数据
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"USERS.Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *awardDic = [message JSONValue];
    NSString *returnCodeStr = [awardDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]){        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_ID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_NAME"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_PASSWORD"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_STATE"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_COMPANY"];
        alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" 
                                           message:@"注销成功！" 
                                          delegate:self 
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self 
                                       selector:@selector(hidderAlert)
                                       userInfo:@"正在更新数据"
                                        repeats:NO];

        //返回主界面
        ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        [self presentModalViewController:VC animated:YES];
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"服务器异常");
        [alert show];
    }

    
}

//关闭websocket
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    [SocketUtils releaseInstance];
}

-(void) hidderAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
