//
//  AwardUser.h
//  ShakeAward
//  抽奖管理员表
//  Created by Dwen on 12-12-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwardUser : NSObject

@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *realName;
@property (strong,nonatomic) NSString *company;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *state;

@end
