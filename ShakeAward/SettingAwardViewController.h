//
//  SettingAwardViewController.h
//  ShakeAward
//  摇奖人对摇奖进行设置
//  Created by Dwen on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketUtils.h"

@interface SettingAwardViewController : UIViewController<SRWebSocketDelegate>
//抽奖等级设置状态
@property (weak, nonatomic) IBOutlet UILabel *awardGradeLab;
//ftp设置状态
@property (weak, nonatomic) IBOutlet UILabel *ftpLab;
//ftp图片上传状态
@property (weak, nonatomic) IBOutlet UILabel *ftpUploadLab;
@property (strong,nonatomic) UIAlertView *alert;

//设置抽奖等级
- (IBAction)setAwardGrade:(id)sender;
//设置FTP参数
- (IBAction)setFTPParams:(id)sender;
//上传奖品图片到ftp
- (IBAction)uploadFTP:(id)sender;
//确定设置
- (IBAction)setFinished:(id)sender;
//返回
- (IBAction)back:(id)sender;
//用户注销
- (IBAction)logout:(id)sender;

@end
