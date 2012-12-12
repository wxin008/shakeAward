//
//  ViewController.h
//  ShakeAward
//  *摇奖系统--（体验移动互联网时代快感，有网络就有时实的抽奖信息）
//  描述：系统以公司为单位。公司有200人，每人一个号，放在同一个箱子里，然后进行随机按一、二、三等奖进行抽取。每个行者等级可设多个，抽奖等级
//  可以由抽奖人登录后进行设置，设置的内容有抽奖等级、抽奖号范围设置、等级出多少个号、摇奖速度、抽奖声音、根据抽奖等级
//  上传对应的奖品图、公司名称、ftp服务器登录账号密码、管理员抽奖号码设置(范围设置)、用户自己号码设置
//  提供抽奖人登录后启动摇奖，下面所有终端(ipod、iphone、ipad、android)只显示摇奖信息。
//  终端可输入自己的摇奖号码，如果抽中的号码与用户终端输入的号码相同用特效提示当前用户获奖。
//  公司名称根据注册邮箱进行找回密码，公司名称唯一。
//  流程：
//  管理人登录抽奖系统-》设置摇奖参数-》进入摇奖大厅-》启动摇奖-》推送启动消息到各终端-》停止摇奖-》推送停止消息及中奖号到各终端-》终端显示获奖提示

//  *技术点：
//  1、服务器与客户端用socket进行通信.Netty
//  2、奖品图片ftp上传  
//  3、由于是socket通信，传送消息时，需要进行标识 [ok]
//  4、Netty中单点推送和多点推送，在服务端进行处理。[ok]
//  5、无网络时进行提示

//  *注意点：
//  1、进数据需要进行验证
//  2、ftp信息加密处理
//  3、已抽过的号码，需要排除掉，不能再次抽奖 [ok]
//  4、一台手机只能设置一个抽奖号？？？？
//  5、登录的用户需要保存到userdefault中，全局时要用到
//  6、注册抽奖人和成员时，需要验证是否有重名
//  7、由于iphone屏幕大小，现只限同时最多抽取4组中奖号码。
//  8、项目结束后，需要析构，viewDidUnload中清nil
//  9、锁屏时，启动需要呼醒抽奖，delegate得进行处理

// 问题：
//  2012-12-10 在级别修改时，数组传参传不过去，后来分单个属性传的，属性json中是数字型的赋给
//  uitextfiled时报错，再次转为nsstring，才可以。？？？？？？

//  *数据库设计：
//  AWARD_USER 抽奖管理员表：ID(ID),NAME(用户名),PASSWORD(登录密码),COMPANY_NAME(公司名称),EMAIL(邮箱)  
//  AWARD_MEMBER 抽奖成员表：
//  AWARD_CAGEGORY 摇奖等级表： ID,AWARD_USER_ID(摇奖用户id),AWARD_NAME(摇奖等级名称),AWARD_GRADE(摇奖等级，一、二、三等),SET_AWARD_NUM(设置一次摇奖出几个号),SET_AWARD_SPEED(设置摇奖速度),SET_AWARD_NO(设置摇奖号范围)
//  AWARD_PICTURE 奖品图片表： ID,AWARD_USER_ID(摇奖用户id),AWARD_CATEGORY_ID(摇奖等级id),PIC_PATH(图片路径)
//  AWARD_FTP 抽奖ftp上传表：ID,AWARD_USER_ID(摇奖用户id),FTP_USER_NAME(ftp登录名),FTP_PASSWORD(ftp登录密码),FTP_URL(ftp服务器地址)
//  
//
//  Created by Dwen on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersViewController.h"
#import "LoginViewController.h"
#import "HelpViewController.h"
#import "ShakeAwardViewController.h"
#import "AddAwardGradeViewController.h"
#import "MemberShakeAwardViewController.h"
#import "SettingAwardViewController.h"

@interface ViewController : UIViewController
//抽奖用户
- (IBAction)userComein:(id)sender;
//抽奖人
- (IBAction)managerComein:(id)sender;
//系统帮助
- (IBAction)help:(id)sender;

@end
