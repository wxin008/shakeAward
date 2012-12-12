//
//  ShakeAwardViewController.m
//  ShakeAward
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShakeAwardViewController.h"
#import "JSON.h"
#import "Constant.h"
#import "RandomUtils.h"
#import "ViewController.h"

@interface ShakeAwardViewController ()

@end

@implementation ShakeAwardViewController
@synthesize scrollView;
@synthesize timer1,timer2,timer3,timer4;
@synthesize toolbar;
@synthesize pickerView;
@synthesize awardSettingBtn;
@synthesize awardRoomLab;
@synthesize stopBtn;
@synthesize startBtn;
@synthesize awardImgArr,awardNumberArr,awardSettingArr,awardMembersNumArr,randomArr,recordRandomArr,winNumbers,speedArr,awardNoBoundaryArr;
@synthesize awardNoLab1,awardNoLab2,awardNoLab3,awardNoLab4;
@synthesize awardMembersNum,speed,awardNoBoundaryStr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [SocketUtils getInstance:self];
        [self getUserAwardSetting];
        //设置ScrollView
        CGSize newSize = CGSizeMake(self.view.frame.size.width/2*3, 80);
        [scrollView setContentSize:newSize];//控件scrollview左右上下滑动范围
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsVerticalScrollIndicator:NO];//不显示垂直滚动条
        [scrollView setShowsHorizontalScrollIndicator:NO];//不显示水平滚动条
        [scrollView setDelegate:self];
        [scrollView setBackgroundColor:[UIColor purpleColor]];//设置背景以区分view与scrollview
        [scrollView setMaximumZoomScale:5];
        [scrollView setMinimumZoomScale:0.2];
        
        //奖品图片
        awardImgArr = [[NSMutableArray alloc] initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg", nil];
        //小图表
        for (int i=0; i<[awardImgArr count]; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((i*100), 0, 120, 110)];
            [imgView setImage:[UIImage imageNamed:[awardImgArr objectAtIndex:i]]];
            [self.scrollView addSubview:imgView];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    awardSettingArr = [[NSMutableArray alloc] initWithObjects:@"请选择",@"一等奖",@"二等奖",@"三等奖",@"四等奖", nil];
//    awardMembersNumArr = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4", nil];
    awardNumberArr = [[NSMutableArray alloc] initWithCapacity:10];
    recordRandomArr = [[NSMutableArray alloc] init];
}

//获取当前抽奖用户级别
- (void) getUserAwardSetting{
    //用户id
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
    //socket请求服务端
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:LOTTERYSETTING_selectAwardSetting forKey:@"requestActs"];
    [awardDic setValue:userIdStr forKey:@"awardUserId"];
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
    NSLog(@"[获取当前用户级别.json] :%@",awardJSON);
}

#pragma PickerView控件
//picker列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//每轮最大轮数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [awardSettingArr count];
}

//行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35.0f;
}

/*
 * row:表示picker中的行 component:表示列的index
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [awardSettingArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    awardMembersNum = [awardMembersNumArr objectAtIndex:row];
    NSString *awardSettingStr = [awardSettingArr objectAtIndex:row];
    if ([[awardMembersNum stringValue] isEqualToString:@"0"]) {
        NSString *userCompany = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_COMPANY"];
        awardRoomLab.text = userCompany;
    }else {
        awardRoomLab.text = [NSString stringWithFormat:@"当前抽取%@位%@",[awardMembersNum stringValue],awardSettingStr];
    }
    //根据抽奖数量加载uilable
    NSLog(@"[awardMembersNum stringValue] ======= %@",[awardMembersNum stringValue]);
    [self madeAwardNoView:[awardMembersNum stringValue]];
    //解析抽奖号
    awardNoBoundaryStr = [awardNoBoundaryArr objectAtIndex:row];
    randomArr = [self madeRandomMembers:awardNoBoundaryStr];
//    randomArr = [self madeRandomMembers:@"500,550"];
    //速度
    speed = [speedArr objectAtIndex:row];
    speed = [NSNumber numberWithDouble:[speed doubleValue]/1000];
    NSLog(@"awardNoBoundaryStr: %@ , speedStr : %g",awardNoBoundaryStr,[speed doubleValue]);
    //推送数据{修改奖级别时推送(奖级别名称、抽奖数量、奖品图、抽奖速度)、开启抽奖时、停止抽奖时}
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:SELECT_AWARD_SETTING forKey:@"requestActs"];//标识抽奖管理员注册
    [awardDic setValue:awardSettingStr forKey:@"awardLevelName"];//抽奖级别名称
    [awardDic setValue:awardMembersNum forKey:@"lotteryMembersNum"];//抽奖数量
    [awardDic setValue:awardImgArr forKey:@"awardPictures"];//级别图片
    [awardDic setValue:speed forKey:@"speed"];//抽奖速度
    [awardDic setValue:randomArr forKey:@"randomAwardNums"];//随机抽奖号
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
    NSLog(@"[选择抽奖级别].json :%@",awardJSON);
}

- (void) madeAwardNoView: (NSString *)num{
    if ([num isEqualToString:@"1"]) {
        [self hiddenLab];
        [self madeLabel1];
    }else if([num isEqualToString:@"2"]){
        [self hiddenLab];
        [self madeLabel1];
        [self madeLabel2];
    }else if([num isEqualToString:@"3"]){
        [self hiddenLab];
        [self madeLabel1];
        [self madeLabel2];
        [self madeLabel3];
    }else if([num isEqualToString:@"4"]){
        [self hiddenLab];
        [self madeLabel1];
        [self madeLabel2];
        [self madeLabel3];
        [self madeLabel4];
    }else {
        [self hiddenLab];
    }
}

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

//生产随机中奖号
-(NSMutableArray *) madeRandomMembers:(NSString *) randomStr{
    return [RandomUtils analysisAwardNo:randomStr];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
//    _webSocket = nil;
    [SocketUtils releaseInstance];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"shakeAward.Received \"%@\"", message);
    if (!message) {
        return;
    }
    NSMutableDictionary *msgDic = [message JSONValue];
    NSArray *objArr = [msgDic objectForKey:@"objList"];
    awardMembersNumArr = [objArr valueForKey:@"lotteryMembersNum"];//抽奖数量
    awardSettingArr = [objArr valueForKey:@"awardLevelName"];//抽奖名称
    speedArr = [objArr valueForKey:@"speed"];//速度
    awardNoBoundaryArr = [objArr valueForKey:@"awardNoBoundary"];//抽奖号边界
    NSString *returnCodeStr = [msgDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        NSLog(@"加载抽奖级成功.");
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        NSLog(@"加载抽奖级失败.");
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
//    _webSocket = nil;
    [SocketUtils releaseInstance];
}

- (IBAction)start:(id)sender {
    NSLog(@"开始抽奖");
    awardSettingBtn.enabled = NO;
    startBtn.enabled = NO;
    //中奖号码
    if (nil == winNumbers) {
        winNumbers = [[NSMutableArray alloc] initWithCapacity:10];
    }else {
        [winNumbers removeAllObjects];//清空中奖号
    }
    
    //排除已抽过的号码 XX如果所有的号码都排除了情况，需要处理？？？
    for (int i=0; i<[recordRandomArr count]; i++) {
        [randomArr removeObject:[recordRandomArr objectAtIndex:i]];
    }
    if ([randomArr count] == 0) {//随机号全部排除后重新生成
        [recordRandomArr removeAllObjects];
        //解析抽奖号
        randomArr = [self madeRandomMembers:awardNoBoundaryStr];
    }
    //生产时钟对象
    if ([[awardMembersNum stringValue] isEqualToString:@"1"]) {
        [self madeTimer1];
        [self pushStartAward];
    }else if ([[awardMembersNum stringValue] isEqualToString:@"2"]) {
        [self madeTimer1];
        [self madeTimer2];
        [self pushStartAward];
    }else if ([[awardMembersNum stringValue] isEqualToString:@"3"]) {
        [self madeTimer1];
        [self madeTimer2];
        [self madeTimer3];
        [self pushStartAward];
    }else if ([[awardMembersNum stringValue] isEqualToString:@"4"]) {
        [self madeTimer1];
        [self madeTimer2];
        [self madeTimer3];
        [self madeTimer4];
        [self pushStartAward];
    }else{
        awardSettingBtn.enabled = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择抽奖级别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//推送抽奖启动信号
- (void) pushStartAward{
    //推送数据{修改奖级别时推送(奖级别名称、抽奖数量、奖品图)、开启抽奖时、停止抽奖时}
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:RUN_AWARD forKey:@"requestActs"];//标识抽奖管理员注册
    [awardDic setValue:awardMembersNum forKey:@"lotteryMembersNum"];//抽奖数量
    [awardDic setValue:START forKey:@"runAward"];
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
    NSLog(@"[启动抽奖].json : %@",awardJSON);
}

- (void) madeTimer1{
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:[speed doubleValue] target:self selector:@selector(handleTime1) userInfo:nil repeats:YES];
}

- (void) madeTimer2{
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:[speed doubleValue] target:self selector:@selector(handleTime2) userInfo:nil repeats:YES];
}

- (void) madeTimer3{
    self.timer3 = [NSTimer scheduledTimerWithTimeInterval:[speed doubleValue] target:self selector:@selector(handleTime3) userInfo:nil repeats:YES];
}

- (void) madeTimer4{
    self.timer4 = [NSTimer scheduledTimerWithTimeInterval:[speed doubleValue] target:self selector:@selector(handleTime4) userInfo:nil repeats:YES];
}

- (void) handleTime1{
    int x = arc4random()%([randomArr count]);
    awardNoLab1.text = [randomArr objectAtIndex:x];
//    int x = (arc4random()%501)+500;//包括500, 不包括1000
//    awardNoLab1.text = [NSString stringWithFormat:@"%i",x];
}

- (void) handleTime2{
    int x = arc4random()%([randomArr count]);
    awardNoLab2.text = [randomArr objectAtIndex:x];
}

- (void) handleTime3{
    int x = arc4random()%([randomArr count]);
    awardNoLab3.text = [randomArr objectAtIndex:x];
}

- (void) handleTime4{
    int x = arc4random()%([randomArr count]);
    awardNoLab4.text = [randomArr objectAtIndex:x];
}

- (IBAction)stop:(id)sender {
    awardSettingBtn.enabled = YES;
    startBtn.enabled = YES;
    //中奖随机号，放入排除数组中
    if ([[awardMembersNum stringValue] isEqualToString:@"1"]) {
        [self invalidateTime1];
        [self pushStopAward];
    }else if ([[awardMembersNum stringValue] isEqualToString:@"2"]) {
        [self invalidateTime1];
        [self invalidateTime2];
        [self pushStopAward];
    }else if ([[awardMembersNum stringValue] isEqualToString:@"3"]) {
        [self invalidateTime1];
        [self invalidateTime2];
        [self invalidateTime3];
        [self pushStopAward];
    }else if ([[awardMembersNum stringValue] isEqualToString:@"4"]) {
        [self invalidateTime1];
        [self invalidateTime2];
        [self invalidateTime3];
        [self invalidateTime4];
        [self pushStopAward];
    }
}

//推送停止抽奖信号
- (void) pushStopAward{
    //推送数据{修改奖级别时推送(奖级别名称、抽奖数量、奖品图)、开启抽奖时、停止抽奖时}
    NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
    [awardDic setValue:STOP_AWARD forKey:@"requestActs"];
    [awardDic setValue:awardMembersNum forKey:@"lotteryMembersNum"];//抽奖数量
    [awardDic setValue:STOP forKey:@"runAward"];
    [awardDic setValue:winNumbers forKey:@"winNumbers"];//中奖号码
    NSString *awardJSON = [awardDic JSONRepresentation];
    [[SocketUtils getInstance:self] send:awardJSON];
    NSLog(@"[停止抽奖].json : %@",awardJSON);
}

- (void) invalidateTime1{
    NSString *awardNo1 = awardNoLab1.text;
    [recordRandomArr addObject:awardNo1];
    [winNumbers addObject:awardNo1];
    [timer1 invalidate];
    timer1 = nil;
}
- (void) invalidateTime2{
    NSString *awardNo2 = awardNoLab2.text;
    [recordRandomArr addObject:awardNo2];
    [winNumbers addObject:awardNo2];
    [timer2 invalidate];
    timer2 = nil;
}
- (void) invalidateTime3{
    NSString *awardNo3 = awardNoLab3.text;
    [recordRandomArr addObject:awardNo3];
    [winNumbers addObject:awardNo3];
    [timer3 invalidate];
    timer3 = nil;
}
- (void) invalidateTime4{
    NSString *awardNo4 = awardNoLab4.text;
    [recordRandomArr addObject:awardNo4];
    [winNumbers addObject:awardNo4];
    [timer4 invalidate];
    timer4 = nil;
}

- (IBAction)back:(id)sender {
    ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
}

- (void)viewDidUnload
{
    [self setTimer1:nil];
    [self setTimer2:nil];
    [self setTimer3:nil];
    [self setTimer4:nil];
    [self setScrollView:nil];
    [self setAwardSettingBtn:nil];
    [self setAwardRoomLab:nil];
    [self setStopBtn:nil];
    [self setStartBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)selectAwardSetting:(id)sender {
    //抽奖按钮不可用
    stopBtn.enabled = NO;
    startBtn.enabled = NO;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *btn_1 = [[UIBarButtonItem alloc] 
                              initWithTitle:@"取消" style:UIBarButtonSystemItemCancel								
                              target:self action:@selector(cancelSelection:)];
    [barItems addObject:btn_1];
    //UIBarButtonSystemItemFlexibleSpace控件进行空格
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] 
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                  target:self action:nil];
    [barItems addObject:flexSpace];
    /*确定按钮 */
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] 
                            initWithTitle:@"确定" style:UIBarButtonItemStyleDone								
                            target:self action:@selector(saveSelection:)];
    [barItems addObject:btn];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 100, 320, 45)];
    //    toolbar.hidden = NO;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar setItems:barItems animated:YES];
    [toolbar sizeToFit];
    [self.view addSubview:toolbar];
    //picker控件
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 140, 320, 150)];
    pickerView.tag = 101;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
}

//点击toolbar确定按钮
-(void)saveSelection:(id)sender{
	toolbar.hidden = YES;
    pickerView.hidden = YES;
    //抽奖按钮不可用
    stopBtn.enabled = YES;
    startBtn.enabled = YES;
}

//点击toolbar取消按钮
-(void)cancelSelection:(id)sender{
    toolbar.hidden = YES;
    pickerView.hidden = YES;
    //抽奖按钮不可用
    stopBtn.enabled = YES;
    startBtn.enabled = YES;
}

@end
