//
//  ShowAwardGradeViewController.h
//  ShakeAward
//  显示抽奖级别
//  Created by Dwen on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SRWebSocket.h"
#import "SocketUtils.h"

@interface ShowAwardGradeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SRWebSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//奖品级别数组
@property (strong,nonatomic) NSArray *awardSettingArr;
@property (strong,nonatomic) NSArray *objArr;
//@property (strong,nonatomic) NSArray *settingArr;

//查询抽奖级别
- (void) selectAwardSetting;
//添加抽奖级别
- (IBAction)addAwardGrade:(id)sender;
//返回
- (IBAction)back:(id)sender;

@end
