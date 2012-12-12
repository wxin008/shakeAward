//
//  DataUtils.m
//  ShakeAward
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils
@synthesize dataDict;

- (NSMutableDictionary *)getData{
    //获取路径  
    NSString *homePath = [[NSBundle mainBundle] executablePath];  
    NSArray *strings = [homePath componentsSeparatedByString: @"/"];  
    NSString *executableName  = [strings objectAtIndex:[strings count]-1];    
    NSString *baseDirectory = [homePath substringToIndex:  
                               [homePath length]-[executableName length]-1];      
    //data.plist文件  
    NSString *filePath = [NSString stringWithFormat:@"%@/data.plist",baseDirectory];    
    dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    return dataDict;
}


- (NSString *) getUserName{
    NSMutableDictionary *userInfo = [self getData];
    NSString *userNameStr = [userInfo objectForKey:@"userName"];
    return userNameStr;
}

- (NSString *) getPassword{
    NSMutableDictionary *userInfo = [self getData];
    NSString *passwordStr = [userInfo objectForKey:@"password"];
    return passwordStr;
}

- (NSArray *) getAwardImages{
    NSMutableDictionary *imagsDic = [self getData];
    NSArray *images = [imagsDic objectForKey:@"AwardImages"];
    return images;
}

+ (DataUtils *)getInstance{
    static DataUtils *instance = nil;
    if (nil == instance) {
        instance = [[DataUtils alloc] init];
    }
    return instance;
}

@end
