//
//  DataUtils.h
//  ShakeAward
//  数据工具类
//  Created by Dwen on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject

@property(strong , nonatomic) NSMutableDictionary *dataDict;

//初始化数据
- (NSMutableDictionary *)getData;
//获取用户名
- (NSString *) getUserName;
//获取用户密码
- (NSString *) getPassword;
//获取抽奖图片
- (NSArray *)getAwardImages;

+ (DataUtils *)getInstance;

@end
