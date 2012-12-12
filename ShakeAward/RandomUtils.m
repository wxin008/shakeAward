//
//  RandomUtils.m
//  ShakeAward
//
//  Created by  on 12-12-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RandomUtils.h"

@implementation RandomUtils

//分解抽奖号
+ (NSMutableArray *) analysisAwardNo : (NSString *)awardNoStr{
    NSMutableArray *awardNoArr = [[NSMutableArray alloc] init];
    NSArray *array = [awardNoStr componentsSeparatedByString:@","];
    NSString *fromAwardNo = [array objectAtIndex:0];
    NSString *toAwardNo = [array objectAtIndex:1];
    int from = [fromAwardNo integerValue];
    int to = [toAwardNo integerValue];
    for (int i=from; i<=to; i++) {
        [awardNoArr addObject:[NSString stringWithFormat:@"%i",i]];
    }
    return awardNoArr;
}

//排除抽奖号
+ (NSMutableArray *) excludeAwardNo :(NSMutableArray *)awardNoArr : (NSString *)awardNoStr{
    NSMutableArray *arr = awardNoArr;
    [arr removeObject:awardNoArr];
    return arr;
}
@end
