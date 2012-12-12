//
//  ShakeAwardViewController.h
//  ShakeAward
//  摇奖界面
//  Created by Dwen on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketUtils.h"
//#import "SRWebSocket.h"
//#import "DataUtils.h"

@interface ShakeAwardViewController : UIViewController<SRWebSocketDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
//奖品图片数据
@property (strong, nonatomic) NSMutableArray *awardImgArr;
//抽奖号码
@property (strong, nonatomic) NSMutableArray *awardNumberArr;
//抽奖级别
@property (strong, nonatomic) NSMutableArray *awardSettingArr;
//抽奖数量
@property (strong, nonatomic) NSMutableArray *awardMembersNumArr;
//随机奖号
@property (strong, nonatomic) NSMutableArray *randomArr;
//获奖号码
@property (strong, nonatomic) NSMutableArray *winNumbers;
//记录已抽过的奖号
@property (strong, nonatomic) NSMutableArray *recordRandomArr;
//速度
@property (strong, nonatomic) NSMutableArray *speedArr;
//抽奖号边界
@property (strong, nonatomic) NSMutableArray *awardNoBoundaryArr;

//定时器
@property (strong, nonatomic) NSTimer *timer1;
@property (strong, nonatomic) NSTimer *timer2;
@property (strong, nonatomic) NSTimer *timer3;
@property (strong, nonatomic) NSTimer *timer4;
//@property (strong,nonatomic) SRWebSocket *_webSocket;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIPickerView *pickerView;
//选择抽奖级别
@property (weak, nonatomic) IBOutlet UIButton *awardSettingBtn;
@property (weak, nonatomic) IBOutlet UILabel *awardRoomLab;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//抽奖号码
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab1;
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab2;
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab3;
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab4;
//抽取数量
@property (strong, nonatomic) NSNumber *awardMembersNum;
//速度
@property (strong, nonatomic) NSNumber *speed;

//抽奖号边界
@property (strong, nonatomic) NSString *awardNoBoundaryStr;


//选择抽奖级别
- (IBAction)selectAwardSetting:(id)sender;
//开始抽奖
- (IBAction)start:(id)sender;
//停止抽奖
- (IBAction)stop:(id)sender;
//返回
- (IBAction)back:(id)sender;
//定时器触发方法
- (void) handleTime;
//初始化socket
//- (void) initSocket;

@end
