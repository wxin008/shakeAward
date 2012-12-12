//
//  UploadImgViewController.h
//  ShakeAward
//  上传奖品图片
//  Created by Dwen on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketUtils.h"

@interface UploadImgViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,SRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIPickerView *pickerView;
//奖品级别
@property (strong, nonatomic) NSArray *settingArr;
//奖品级别id
@property (strong, nonatomic) NSArray *settingIDArr;
//奖品图片
@property (strong, nonatomic) NSMutableArray *awardPicArr;
//当前级别id
@property (strong, nonatomic) NSString *settingId;
//级别按钮
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

//上传图片
- (IBAction)uploadPic:(id)sender;
//选择抽奖级别
- (IBAction)chooseAwardGrade:(id)sender;
//返回
- (IBAction)back:(id)sender;

@end
