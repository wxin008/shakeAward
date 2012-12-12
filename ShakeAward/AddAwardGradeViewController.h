//
//  AddAwardGradeViewController.h
//  ShakeAward
//  设置奖品级别
//  Created by Dwen on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SRWebSocket.h"
#import "SocketUtils.h"

@interface AddAwardGradeViewController : UIViewController<SRWebSocketDelegate,UITextFieldDelegate>
//抽奖号From
@property (weak, nonatomic) IBOutlet UITextField *awardNoFrom;
//抽奖号To
@property (weak, nonatomic) IBOutlet UITextField *awardNoTo;
//抽奖速度
@property (weak, nonatomic) IBOutlet UITextField *awardSpeed;
//抽奖等级
@property (weak, nonatomic) IBOutlet UITextField *awardGrade;
//抽奖等级名称
@property (weak, nonatomic) IBOutlet UITextField *awardGradeName;
//抽奖数量
@property (weak, nonatomic) IBOutlet UITextField *awardNoGroup;
//抽奖排序
@property (weak, nonatomic) IBOutlet UITextField *awardOrder;
//中奖提示信息
@property (weak, nonatomic) IBOutlet UITextField *awardMessage;

@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
//添加与修改标识
@property (strong,nonatomic) NSString *isFlag;
//当前级别id
@property (strong,nonatomic) NSString *idStr;
@property (strong,nonatomic) NSString *awardLevelCodeStr;
@property (strong,nonatomic) NSString *awardLevelNameStr;
@property (strong,nonatomic) NSString *lotteryMembersNumStr;
@property (strong,nonatomic) NSString *awardOrderStr;
@property (strong,nonatomic) NSString *speedStr;
@property (strong,nonatomic) NSString *awardNoBoundaryStr;
@property (strong,nonatomic) NSString *messageStr;

//@property (strong,nonatomic) SRWebSocket *_webSocket;
//@property (strong,nonatomic) NSMutableArray *awardArr;

//确定添加抽奖等级
- (void)addFinished;
//返回
- (IBAction)back:(id)sender;

@end
