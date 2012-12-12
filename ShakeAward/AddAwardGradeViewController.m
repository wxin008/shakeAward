//
//  AddAwardGradeViewController.m
//  ShakeAward
//
//  Created by  on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddAwardGradeViewController.h"
#import "Constant.h"
#import "ShowAwardGradeViewController.h"
#import "JSON.h"
#import "LoginViewController.h"


@interface AddAwardGradeViewController ()

@end

@implementation AddAwardGradeViewController
@synthesize awardNoFrom;
@synthesize awardNoTo;
@synthesize awardSpeed;
@synthesize awardGrade;
@synthesize awardGradeName;
@synthesize awardNoGroup;
@synthesize awardOrder;
@synthesize awardMessage;
@synthesize main_view;
@synthesize okBtn;
//@synthesize awardArr;
@synthesize isFlag;
@synthesize idStr,awardLevelCodeStr,awardLevelNameStr,lotteryMembersNumStr,awardOrderStr,speedStr,awardNoBoundaryStr,messageStr;
//@synthesize _webSocket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [SocketUtils getInstance:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //加载修改抽奖级别信息
    if ([isFlag isEqualToString:MODIFY_FLAG]) {
        okBtn.titleLabel.text = @"修改";
        [okBtn addTarget:self action:@selector(addFinished) forControlEvents:UIControlEventTouchUpInside];
        idStr = idStr;
        awardGrade.text = awardLevelCodeStr;
        awardGradeName.text = awardLevelNameStr;
        NSLog(@"lotteryMembersNumStr : %@",lotteryMembersNumStr);
        awardNoGroup.text = [NSString stringWithFormat:@"%@",lotteryMembersNumStr];
        awardOrder.text = [NSString stringWithFormat:@"%@",awardOrderStr];
        awardSpeed.text = [NSString stringWithFormat:@"%@",speedStr];
        NSArray *awardNoBoundaryArr = [awardNoBoundaryStr componentsSeparatedByString:@","];
        awardNoFrom.text = [awardNoBoundaryArr objectAtIndex:0];
        awardNoTo.text = [awardNoBoundaryArr objectAtIndex:1];
        awardMessage.text = messageStr;
        
//        idStr = [awardArr valueForKey:@"id"];
//        awardGrade.text = [awardArr valueForKey:@"awardLevelCode"];;
//        awardGradeName.text = [awardArr valueForKey:@"awardLevelName"];
//        awardNoGroup.text = [awardArr valueForKey:@"lotteryMembersNum"];
//        awardOrder.text = [awardArr valueForKey:@"awardOrder"];
//        awardSpeed.text = [awardArr valueForKey:@"speed"];
//        NSString *awardNoBoundaryStr = [awardArr valueForKey:@"awardNoBoundary"];
//        NSArray *awardNoBoundaryArr = [awardNoBoundaryStr componentsSeparatedByString:@","];
//        awardNoFrom.text = [awardNoBoundaryArr objectAtIndex:0];
//        awardNoTo.text = [awardNoBoundaryArr objectAtIndex:1];
//        awardMessage.text = [awardArr valueForKey:@"message"];
    }else {
        isFlag = ADD_FLAG;
        okBtn.titleLabel.text = @"确定";
        [okBtn addTarget:self action:@selector(addFinished) forControlEvents:UIControlEventTouchUpInside];
    }
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
    NSLog(@"Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *msgDic = [message JSONValue];
    NSString *returnCodeStr =[msgDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        if ([isFlag isEqualToString:MODIFY_FLAG]) {
            UIAlertView *alert = ALERT_MESSAGE(@"提示", @"成功修改抽奖级别");
            [alert show];
        }else if ([isFlag isEqualToString:ADD_FLAG]) {
            UIAlertView *alert = ALERT_MESSAGE(@"提示", @"成功添加抽奖级别");
            [alert show];
        }
        //请求成功，跳到显示抽奖级别
        ShowAwardGradeViewController *showAwardGradeVC = [[ShowAwardGradeViewController alloc] initWithNibName:@"ShowAwardGradeViewController" bundle:nil];
        [self presentModalViewController:showAwardGradeVC animated:YES];
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"添加抽奖级别失败");
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
    [self setAwardNoFrom:nil];
    [self setAwardNoTo:nil];
    [self setAwardSpeed:nil];
    [self setAwardGrade:nil];
    [self setAwardGradeName:nil];
    [self setAwardNoGroup:nil];
    [self setAwardOrder:nil];
    [self setAwardMessage:nil];
    [self setMain_view:nil];
    [self setOkBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addFinished {
    NSString *awardNoFromStr = awardNoFrom.text;
    NSString *awardNoToStr = awardNoTo.text;
    NSString *awardSpeedStr = awardSpeed.text;
    NSString *awardGradeStr = awardGrade.text;
    NSString *awardGradeNameStr = awardGradeName.text;
    NSString *awardNoGroupStr = awardNoGroup.text;
    NSString *awardMessageStr = awardMessage.text;
    NSString *awardOrderStr = awardOrder.text;
    if ([awardGradeStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖等级不能为空");
        [alert show];
    }else if ([awardGradeNameStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖等级名称不能为空");
        [alert show];
    }else if ([awardNoGroupStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖号码数量不能为空");
        [alert show];
    }else if ([awardOrderStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖排序不能为空");
        [alert show];
    }else if ([awardSpeedStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖速度不能为空");
        [alert show];
    }else if ([awardNoFromStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖号开始范围不能为空");
        [alert show];
    }else if ([awardNoToStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖号结束范围不能为空");
        [alert show];
    }else if ([awardMessageStr length] == 0) {
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖提示信息不能为空");
        [alert show];
    }else {
        NSString *awardNoBoundaryStr = [NSString stringWithFormat:@"%@,%@",awardNoFromStr,awardNoToStr];
        //用户id
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
        if (userId > 0) {
            //socket请求服务端
            NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
            if ([isFlag isEqualToString:MODIFY_FLAG]) {
                [awardDic setValue:LOTTERYSETTING_updateAwardSetting forKey:@"requestActs"];
                [awardDic setValue:idStr forKey:@"id"];
            }else if([isFlag isEqualToString:ADD_FLAG]){
                [awardDic setValue:LOTTERYSETTING_addAwardSetting forKey:@"requestActs"];
            }
            [awardDic setValue:userId forKey:@"awardUserId"];
            [awardDic setValue:awardGradeStr forKey:@"awardLevelCode"];
            [awardDic setValue:awardGradeNameStr forKey:@"awardLevelName"];
            [awardDic setValue:awardNoGroupStr forKey:@"lotteryMembersNum"];
            [awardDic setValue:awardOrderStr forKey:@"awardOrder"];
            [awardDic setValue:awardSpeedStr forKey:@"speed"];
            [awardDic setValue:awardNoBoundaryStr forKey:@"awardNoBoundary"];
            [awardDic setValue:awardMessageStr forKey:@"message"];
            NSString *awardJSON = [awardDic JSONRepresentation];
            [[SocketUtils getInstance:self] send:awardJSON];
            NSLog(@"[AddAwardSetting.json] : %@",awardJSON);
        }else {
            LoginViewController *VC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self presentModalViewController:VC animated:YES];
        }
    }
}
     

- (IBAction)back:(id)sender {
    ShowAwardGradeViewController *VC = [[ShowAwardGradeViewController alloc] initWithNibName:@"ShowAwardGradeViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
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
    if (textField == awardNoFrom || textField == awardNoTo) {
         main_view.frame = CGRectMake(0, -20, 320, 367);
    }else if(textField == awardMessage){
        main_view.frame = CGRectMake(0, -40, 320, 367);
    }
    [UIView commitAnimations];
}

@end
