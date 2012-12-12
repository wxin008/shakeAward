//
//  Constant.h
//  ShakeAward
//  系统常量
//  Created by  on 12-11-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//websocket服务
//#define WEBSOCKET_SERVER @"ws://127.0.0.1:8080/websocket"
#define WEBSOCKET_SERVER @"ws://192.168.6.95:8080/websocket"

//返回状态
//成功
#define RETURN_SUCCESS @"0"
//失败
#define RETURN_FAILURE @"500"
//开始抽奖
#define START @"START"
//停止抽奖
#define STOP @"STOP"

//抽奖人角色
#define ROLE_USER @"USER"
//成员角色
#define ROLE_MEMBER @"MEMBER"

//修改级别标识
#define MODIFY_FLAG @"modify"
//添加级别标识
#define ADD_FLAG @"add"

//json字段名(约定：Oc与java对象名称相同，java对象属性名称与数据库字段名相同)


//ftp服务


//请求行为 参数以对象为单位。格式：参数对象=接口实现类=实现方法
#define AWARDUSER_loginUser @"AwardUser=AwardServiceImpl=loginUser"

#define AWARDUSER_registerUser @"AwardUser=AwardServiceImpl=registerUser"

#define AWARDMEMBER_loginMemger @"AwardMember=AwardServiceImpl=loginMember"

#define AWARD_logout @"Award=AwardServiceImpl=logout"

#define AWARDFTP_addWardFtp @"AwardFtp=AwardServiceImpl=addAwardFtp"

#define AWARDFTP_selectAwardFtp @"AwardFtp=AwardServiceImpl=selectAwardFtp"

#define AWARDFTP_updateWardFtp @"AwardFtp=AwardServiceImpl=updateAwardFtp"

#define AWARDPICTURE_addAwardPicture @"AwardPicture=AwardServiceImpl=addAwardPicture"

#define LOTTERYSETTING_selectAwardSetting @"AwardLotterySetting=AwardServiceImpl=selectAwardSetting"

#define LOTTERYSETTING_addAwardSetting @"AwardLotterySetting=AwardServiceImpl=addAwardSetting"
#define LOTTERYSETTING_updateAwardSetting @"AwardLotterySetting=AwardServiceImpl=updateAwardSetting"
//修改奖级别时推送(奖级别名称、抽奖数量、奖品图)
#define SELECT_AWARD_SETTING @"PUSH_DATA=SELECT_SETTING=NONE"
//开启抽奖时
#define RUN_AWARD @"PUSH_DATA=RUN_AWARD=NONE"
//停止抽奖
#define STOP_AWARD @"PUSH_DATA=STOP_AWARD=NONE"

//消息提示定义
#define ALERT_MESSAGE(title,msg) [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

@interface Constant : NSObject

@end
