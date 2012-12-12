//
//  ShowAwardGradeViewController.m
//  ShakeAward
//
//  Created by  on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShowAwardGradeViewController.h"
#import "AddAwardGradeViewController.h"
#import "SettingAwardViewController.h"
#import "JSON.h"
#import "Constant.h"

@interface ShowAwardGradeViewController ()

@end

@implementation ShowAwardGradeViewController
@synthesize tableView;
//@synthesize webSocket;
@synthesize awardSettingArr,objArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [SocketUtils getInstance:self];
        //查询奖品级别
        [self selectAwardSetting];
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
//    webSocket = nil;
    [SocketUtils releaseInstance];
}

//接收数据
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"ShowAwardGradeView.Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *msgDic = [message JSONValue];
    objArr = [msgDic objectForKey:@"objList"];
    awardSettingArr = [objArr valueForKey:@"awardLevelName"];//抽奖名称
    NSString *returnCodeStr = [msgDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        [self.tableView reloadData];
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"抽奖级别加载异常");
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
    [self setTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) selectAwardSetting {
    //socket请求服务端
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
    NSLog(@"userIdStr :%@",userIdStr);
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:LOTTERYSETTING_selectAwardSetting forKey:@"requestActs"];
    [awardDic setValue:userIdStr forKey:@"awardUserId"];
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
}

- (IBAction)addAwardGrade:(id)sender {
    AddAwardGradeViewController *addAwardGradeVC = [[AddAwardGradeViewController alloc] initWithNibName:@"AddAwardGradeViewController" bundle:nil];
    [self presentModalViewController:addAwardGradeVC animated:YES];
}

- (IBAction)back:(id)sender {
    SettingAwardViewController *settingAwardVC = [[SettingAwardViewController alloc] initWithNibName:@"SettingAwardViewController" bundle:nil];
    [self presentModalViewController:settingAwardVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [awardSettingArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *awardLevelName = [awardSettingArr objectAtIndex:indexPath.row];
    cell.textLabel.text = awardLevelName;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *settingArr = [objArr objectAtIndex:indexPath.row];
    AddAwardGradeViewController *aagVC = [[AddAwardGradeViewController alloc] initWithNibName:@"AddAwardGradeViewController" bundle:nil];
    aagVC.isFlag = MODIFY_FLAG;
    aagVC.idStr = [settingArr valueForKey:@"id"];
    aagVC.awardLevelCodeStr = [settingArr valueForKey:@"awardLevelCode"];;
    aagVC.awardLevelNameStr = [settingArr valueForKey:@"awardLevelName"];
    aagVC.lotteryMembersNumStr = [settingArr valueForKey:@"lotteryMembersNum"];
    aagVC.awardOrderStr = [settingArr valueForKey:@"awardOrder"];
    aagVC.speedStr = [settingArr valueForKey:@"speed"];
    aagVC.awardNoBoundaryStr = [settingArr valueForKey:@"awardNoBoundary"];
    aagVC.messageStr = [settingArr valueForKey:@"message"];
    [self presentModalViewController:aagVC animated:YES];
}

@end
