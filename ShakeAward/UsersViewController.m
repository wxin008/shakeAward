//
//  UsersViewController.m
//  ShakeAward
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UsersViewController.h"
#import "ViewController.h"

@interface UsersViewController ()

@end

@implementation UsersViewController
@synthesize managerNo;
@synthesize awardNo;
@synthesize companyName;
@synthesize realName;
@synthesize department;
@synthesize userName;
@synthesize main_view;
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
    NSLog(@"USERS.Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *loginDic = [message JSONValue];
    //成员id
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"id"] forKey:@"MEMBER_ID"];
    NSLog(@"id========%@",[loginDic objectForKey:@"id"]);
    //保存成员名称
//    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"memberName"] forKey:@"MEMBER_NAME"];
    //保存成员奖号
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"lotteryCode"] forKey:@"LOTTERY_CODE"];
    //保存用户名
//    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"awardUserName"] forKey:@"MEMBER_USER_NAME"];
    //保存成员登录状态
    [[NSUserDefaults standardUserDefaults] setObject:[loginDic objectForKey:@"state"] forKey:@"MEMBER_STATE"];
    NSString *returnCodeStr = [loginDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        //保存用户抽奖号
        [[NSUserDefaults standardUserDefaults] setObject:awardNo.text forKey:@"USER_AWARD_NO"];
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
        //进入成员抽奖界面
        MemberShakeAwardViewController *memberVC = [[MemberShakeAwardViewController alloc] initWithNibName:@"MemberShakeAwardViewController" bundle:nil];
        [self presentModalViewController:memberVC animated:YES];
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        alert = ALERT_MESSAGE(@"提示", @"登录异常");
        [alert show];
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
    [self setAwardNo:nil];
    [self setManagerNo:nil];
    [self setCompanyName:nil];
    [self setRealName:nil];
    [self setDepartment:nil];
    [self setUserName:nil];
    [self setMain_view:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveAwardNo:(id)sender {
    NSString *managerStr = managerNo.text;
    NSString *awardStr = awardNo.text;
    NSString *companyNameStr = companyName.text;
    NSString *realNameStr = realName.text;
    NSString *departmentStr = department.text;
    NSString *userNameStr = userName.text;
    if ([managerStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖管理员ID不能为空");
        [alert show];
    }else if([companyNameStr length] == 0){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"公司名称不能为空");
        [alert show];
    }else if([realNameStr length] == 0){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"真实姓名不能为空");
        [alert show];
    }else if([departmentStr length] == 0){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"所在部门不能为空");
        [alert show];
    }else if([userNameStr length] == 0){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"用户名不能为空");
        [alert show];
    }else if([awardStr length] == 0){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖号不能为空");
        [alert show];
    }else {
        NSLog(@"抽奖管理员id: %@ ,抽奖号码为：%@",managerStr,awardStr);
        //保存抽奖号码到data.plist文件中,中奖时需要该数据进行匹配是否中奖
        //到服务端验证是否通过
        //socket请求服务端
        NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
        [awardDic setValue:AWARDMEMBER_loginMemger forKey:@"requestActs"];        [awardDic setValue:managerStr forKey:@"awardUserName"];
        [awardDic setValue:companyNameStr forKey:@"company"];
        [awardDic setValue:userNameStr forKey:@"userName"];
        [awardDic setValue:realNameStr forKey:@"memberName"];
        [awardDic setValue:departmentStr forKey:@"department"];
        [awardDic setValue:awardStr forKey:@"lotteryCode"];
        NSString *awardJSON = [awardDic JSONRepresentation];
        [[SocketUtils getInstance:self] send:awardJSON];
        NSLog(@"[抽奖成员登录].json : %@",awardJSON);
        
    }
}

- (IBAction)back:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
}

-(void) hidderAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    main_view.frame = CGRectMake(0, 50, 320, 367);
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if (textField == userName) {
        main_view.frame = CGRectMake(0, -10, 320, 367);
    }else if (textField == awardNo) {
        main_view.frame = CGRectMake(0, -20, 320, 367);
    }
    [UIView commitAnimations];
}


@end
