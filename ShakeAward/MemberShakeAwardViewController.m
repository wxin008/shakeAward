//
//  MemberShakeAwardViewController.m
//  ShakeAward
//
//  Created by  on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MemberShakeAwardViewController.h"
#import "Constant.h"

@interface MemberShakeAwardViewController ()

@end

@implementation MemberShakeAwardViewController
@synthesize awardRoomLab;
@synthesize scrollView;
@synthesize awardImgArr;
@synthesize timer1,timer2,timer3,timer4;
@synthesize awardNoLab1,awardNoLab2,awardNoLab3,awardNoLab4;
@synthesize randomAwardNumArr,winNumbersArr;
@synthesize speedStr;
@synthesize lotteryMembersNumStr;
@synthesize flag;
@synthesize alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //socket
        [SocketUtils getInstance:self];
        //设置ScrollView
        CGSize newSize = CGSizeMake(self.view.frame.size.width*3, 80);
        [scrollView setContentSize:newSize];//控件scrollview左右上下滑动范围
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsVerticalScrollIndicator:NO];//不显示垂直滚动条
        [scrollView setShowsHorizontalScrollIndicator:NO];//不显示水平滚动条
        [scrollView setDelegate:self];
        [scrollView setBackgroundColor:[UIColor purpleColor]];//设置背景以区分view与scrollview
        [scrollView setMaximumZoomScale:5];
        [scrollView setMinimumZoomScale:0.2];
        
        //奖品图片
//        awardImgArr = [[NSMutableArray alloc] initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg", nil];
        //小图表
//        for (int i=0; i<[awardImgArr count]; i++) {
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i*210), 5, 200, 200)];
//            [imgView setImage:[UIImage imageNamed:[awardImgArr objectAtIndex:i]]];
//            [self.scrollView addSubview:imgView];
//        }

    }
    return self;
}

#pragma 界面元素
- (void) madeLabel1{
    awardNoLab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 300, 40)];
    awardNoLab1.text = @"XXXX";
    awardNoLab1.font = [UIFont fontWithName:@"Arial" size:30];
    awardNoLab1.textColor = [UIColor redColor];
    awardNoLab1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:awardNoLab1];
    
}
- (void) madeLabel2{
    awardNoLab2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 70, 300, 40)];
    awardNoLab2.text = @"XXXX";
    awardNoLab2.font = [UIFont fontWithName:@"Arial" size:30];
    awardNoLab2.textColor = [UIColor redColor];
    awardNoLab2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:awardNoLab2];
}
- (void) madeLabel3{
    awardNoLab3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 300, 40)];
    awardNoLab3.text = @"XXXX";
    awardNoLab3.font = [UIFont fontWithName:@"Arial" size:30];
    awardNoLab3.textColor = [UIColor redColor];
    awardNoLab3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:awardNoLab3];
}
- (void) madeLabel4{
    awardNoLab4 = [[UILabel alloc] initWithFrame:CGRectMake(200, 140, 300, 40)];
    awardNoLab4.text = @"XXXX";
    awardNoLab4.font = [UIFont fontWithName:@"Arial" size:30];
    awardNoLab4.textColor = [UIColor redColor];
    awardNoLab4.backgroundColor = [UIColor clearColor];
    [self.view addSubview:awardNoLab4];
}

//隐藏奖号码
- (void)hiddenLab{
    awardNoLab1.hidden = YES;
    awardNoLab2.hidden = YES;
    awardNoLab3.hidden = YES;
    awardNoLab4.hidden = YES;
}

- (void) madeTimer1{
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:[speedStr doubleValue] target:self selector:@selector(handleTime1) userInfo:nil repeats:YES];
}

- (void) madeTimer2{
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:[speedStr doubleValue] target:self selector:@selector(handleTime2) userInfo:nil repeats:YES];
}

- (void) madeTimer3{
    self.timer3 = [NSTimer scheduledTimerWithTimeInterval:[speedStr doubleValue] target:self selector:@selector(handleTime3) userInfo:nil repeats:YES];
}

- (void) madeTimer4{
    self.timer4 = [NSTimer scheduledTimerWithTimeInterval:[speedStr doubleValue] target:self selector:@selector(handleTime4) userInfo:nil repeats:YES];
}

- (void) invalidateTime1{
    awardNoLab1.text = [winNumbersArr objectAtIndex:0];
    [timer1 invalidate];
    timer1 = nil;
}
- (void) invalidateTime2{
    awardNoLab2.text = [winNumbersArr objectAtIndex:1];
    [timer2 invalidate];
    timer2 = nil;
}
- (void) invalidateTime3{
    awardNoLab3.text = [winNumbersArr objectAtIndex:2];
    [timer3 invalidate];
    timer3 = nil;
}
- (void) invalidateTime4{
    awardNoLab4.text = [winNumbersArr objectAtIndex:3];
    [timer4 invalidate];
    timer4 = nil;
}

- (void) handleTime1{
    int x = arc4random()%([randomAwardNumArr count]);
    awardNoLab1.text = [randomAwardNumArr objectAtIndex:x];
}

- (void) handleTime2{
    int x = arc4random()%([randomAwardNumArr count]);
    awardNoLab2.text = [randomAwardNumArr objectAtIndex:x];
}

- (void) handleTime3{
    int x = arc4random()%([randomAwardNumArr count]);
    awardNoLab3.text = [randomAwardNumArr objectAtIndex:x];
}

- (void) handleTime4{
    int x = arc4random()%([randomAwardNumArr count]);
    awardNoLab4.text = [randomAwardNumArr objectAtIndex:x];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setAwardRoomLab:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender {
    ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
}

- (IBAction)logout:(id)sender {
    //socket请求服务端
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:AWARD_logout forKey:@"requestActs"];      
    [awardDic setValue:ROLE_MEMBER forKey:@"role"];
    NSString *memberId =[[NSUserDefaults standardUserDefaults] objectForKey:@"MEMBER_ID"];
    [awardDic setValue:memberId forKey:@"id"];
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
    NSLog(@"[抽奖成员登出].json : %@",awardJSON);
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    [SocketUtils releaseInstance];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"MemberShakeAward.Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *awardDic = [message JSONValue];
    NSString *requestActStr = [awardDic objectForKey:@"requestActs"];//请求行为
    NSString *returnCodeStr = [awardDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]){
        //获取推送抽奖信息
        if ([requestActStr isEqualToString:SELECT_AWARD_SETTING]) {
            speedStr = [awardDic objectForKey:@"speed"];//抽奖速度
            randomAwardNumArr = [awardDic objectForKey:@"randomAwardNums"];//随机抽奖号码
            NSString *awardLevelNameStr =[awardDic objectForKey:@"awardLevelName"];//级别名称
            lotteryMembersNumStr =[awardDic objectForKey:@"lotteryMembersNum"];//抽奖数量
            awardRoomLab.text = [NSString stringWithFormat:@"当前抽取%@位%@",lotteryMembersNumStr,awardLevelNameStr];
            //加载抽奖号Lable
            if ([lotteryMembersNumStr isEqualToString:@"1"]) {
                [self hiddenLab];
                [self madeLabel1];
            }else if([lotteryMembersNumStr isEqualToString:@"2"]){
                [self hiddenLab];
                [self madeLabel1];
                [self madeLabel2];
            }else if([lotteryMembersNumStr isEqualToString:@"3"]){
                [self hiddenLab];
                [self madeLabel1];
                [self madeLabel2];
                [self madeLabel3];
            }else if([lotteryMembersNumStr isEqualToString:@"4"]){
                [self hiddenLab];
                [self madeLabel1];
                [self madeLabel2];
                [self madeLabel3];
                [self madeLabel4];
            }
            //级别图片
            awardImgArr = [awardDic objectForKey:@"awardPictures"];
            for (int i=0; i<[awardImgArr count]; i++) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i*210), 5, 200, 200)];
                [imgView setImage:[UIImage imageNamed:[awardImgArr objectAtIndex:i]]];
                [self.scrollView addSubview:imgView];
            }
        }else if ([requestActStr isEqualToString:RUN_AWARD]){//开始抽奖
            //生产时钟对象
            if ([lotteryMembersNumStr isEqualToString:@"1"]) {
                [self madeTimer1];
            }else if ([lotteryMembersNumStr isEqualToString:@"2"]) {
                [self madeTimer1];
                [self madeTimer2];
            }else if ([lotteryMembersNumStr isEqualToString:@"3"]) {
                [self madeTimer1];
                [self madeTimer2];
                [self madeTimer3];
            }else if ([lotteryMembersNumStr isEqualToString:@"4"]) {
                [self madeTimer1];
                [self madeTimer2];
                [self madeTimer3];
                [self madeTimer4];
            }
        }else if ([requestActStr isEqualToString:STOP_AWARD]){//停止抽奖
            winNumbersArr = [awardDic objectForKey:@"winNumbers"];//中奖号码
            if ([lotteryMembersNumStr isEqualToString:@"1"]) {
                [self invalidateTime1];
            }else if ([lotteryMembersNumStr isEqualToString:@"2"]) {
                [self invalidateTime1];
                [self invalidateTime2];
            }else if ([lotteryMembersNumStr isEqualToString:@"3"]) {
                [self invalidateTime1];
                [self invalidateTime2];
                [self invalidateTime3];
            }else if ([lotteryMembersNumStr isEqualToString:@"4"]) {
                [self invalidateTime1];
                [self invalidateTime2];
                [self invalidateTime3];
                [self invalidateTime4];
            }
            //如果用户获奖，恭喜用户中奖
            NSString * userAwardNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_AWARD_NO"];
            for (int i=0; i<[winNumbersArr count]; i++) {
                if ([userAwardNo isEqualToString:[winNumbersArr objectAtIndex:i]]) {
                    flag = YES;
                }else {
                    flag = NO;
                }
                if (flag) {//一个成员一次抽奖只能中一个号码
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您中奖啦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }else if([requestActStr isEqualToString:AWARD_logout]){//成员登出
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MEMBER_ID"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LOTTERY_CODE"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MEMBER_STATE"];
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
        }
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        UIAlertView *alert = ALERT_MESSAGE(@"提示", @"服务器异常");
        [alert show];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    [SocketUtils releaseInstance];
}

-(void) hidderAlert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
