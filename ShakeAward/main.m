//
//  main.m
//  ShakeAward
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "RandomUtils.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
//        NSMutableArray *arr = [RandomUtils analysisAwardNo:@"500,550"];
//        for (int i=0; i<[arr count]; i++) {
//            NSLog(@"%i ,%@",i,[arr objectAtIndex:i]);
//        }
//        [arr removeObject:@"508"];
////        NSMutableArray *arr2 = [RandomUtils excludeAwardNo:arr :@"508"];
//        for (int i=0; i<[arr count]; i++) {
//            NSLog(@"==%i ,%@",i,[arr objectAtIndex:i]);
//        }
//        int x = arc4random()%([arr count]+1);//包括500, 不包括1000
//        NSString *xStr = [arr objectAtIndex:x];
//        NSLog(@"%i ,%@",x,xStr);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
