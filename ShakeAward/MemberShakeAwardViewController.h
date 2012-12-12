//
//  MemberShakeAwardViewController.h
//  ShakeAward
//  显示成员抽奖结果
//  Created by Dwen on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SocketUtils.h"

@interface MemberShakeAwardViewController : UIViewController<SRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UILabel *awardRoomLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) UIAlertView *alert;

@property (strong,nonatomic) NSMutableArray *awardImgArr;
//定时器
@property (strong, nonatomic) NSTimer *timer1;
@property (strong, nonatomic) NSTimer *timer2;
@property (strong, nonatomic) NSTimer *timer3;
@property (strong, nonatomic) NSTimer *timer4;
//抽奖号码
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab1;
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab2;
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab3;
@property (strong, nonatomic) IBOutlet UILabel *awardNoLab4;
//抽奖数量
@property (strong, nonatomic) NSString *lotteryMembersNumStr;
//中奖号
@property (strong, nonatomic) NSArray *winNumbersArr;
//抽奖随机数
@property (strong, nonatomic) NSArray *randomAwardNumArr;
//抽奖速度
@property (strong, nonatomic) NSString *speedStr;
//标识是中奖
@property (nonatomic) BOOL flag;
//返回
- (IBAction)back:(id)sender;
//成员登出
- (IBAction)logout:(id)sender;

@end
