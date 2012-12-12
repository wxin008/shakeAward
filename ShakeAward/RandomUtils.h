//
//  RandomUtils.h
//  ShakeAward
//  抽奖号随机数
//  Created by Dwen on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomUtils : NSObject

//分解抽奖号
+ (NSMutableArray *) analysisAwardNo : (NSString *)awardNoStr;
//排除抽奖号
+ (NSMutableArray *) excludeAwardNo :(NSMutableArray *)awardNoArr : (NSString *)awardNoStr;
@end
