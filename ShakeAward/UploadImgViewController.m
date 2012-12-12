//
//  UploadImgViewController.m
//  ShakeAward
//
//  Created by  on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UploadImgViewController.h"
#import "SettingAwardViewController.h"
#import "Constant.h"
#import "JSON.h"

@interface UploadImgViewController ()

@end

@implementation UploadImgViewController
@synthesize tableView;
@synthesize pickerView;
@synthesize settingArr,settingIDArr;
@synthesize settingBtn;
@synthesize toolbar;
@synthesize awardPicArr;
@synthesize settingId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [SocketUtils getInstance:self];
        [self getUserAwardSetting];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    settingArr = [[NSMutableArray alloc] initWithObjects:@"一等奖",@"二等奖",@"三等奖", nil];
    awardPicArr = [[NSMutableArray alloc] initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil];
}

#pragma PickerView控件
//picker列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//每轮最大轮数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [settingArr count];
}

//行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}

/*
 * row:表示picker中的行 component:表示列的index
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [settingArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    settingBtn.titleLabel.text =[settingArr objectAtIndex:row];
    settingId = [settingIDArr objectAtIndex:row];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSettingBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)uploadPic:(id)sender {
    //ftp上传
}

- (IBAction)chooseAwardGrade:(id)sender {
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
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 50, 320, 45)];
//    toolbar.hidden = NO;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar setItems:barItems animated:YES];
    [toolbar sizeToFit];
    [self.view addSubview:toolbar];
    //picker控件
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 88, 320, 150)];
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
}

//点击toolbar取消按钮
-(void)cancelSelection:(id)sender{
    toolbar.hidden = YES;
    pickerView.hidden = YES;
}

- (IBAction)back:(id)sender {
    //级别设置界面
    SettingAwardViewController *settingVC = [[SettingAwardViewController alloc] initWithNibName:@"SettingAwardViewController" bundle:nil];
    [self presentModalViewController:settingVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"awardPicArr.count : %i",[awardPicArr count]);
    return [awardPicArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:[awardPicArr objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
    NSArray *objArr = [msgDic objectForKey:@"objList"];
    settingIDArr = [objArr valueForKey:@"id"];//抽奖id
    settingArr = [objArr valueForKey:@"awardLevelName"];//抽奖名称
    NSString *returnCodeStr = [msgDic objectForKey:@"returnCode"];
    if ([returnCodeStr isEqualToString:RETURN_SUCCESS]) {
        settingBtn.titleLabel.text = [settingArr objectAtIndex:0];
        settingId = [settingIDArr objectAtIndex:0];
        NSLog(@"加载抽奖级成功.");
    }else if([returnCodeStr isEqualToString:RETURN_FAILURE]){
        NSLog(@"加载抽奖级失败.");
    }
}

//关闭websocket
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    [SocketUtils releaseInstance];
}
@end
