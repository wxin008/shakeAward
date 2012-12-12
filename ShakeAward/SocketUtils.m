//
//  SocketUtils.m
//  ShakeAward
//
//  Created by  on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SocketUtils.h"
#import "Constant.h"
#import "JSON.h"

@implementation SocketUtils

static SocketUtils *instance = nil;

+ (SocketUtils *)getInstance : (id)delegate{
    if (nil == instance) {
        //Socket
        instance = [[SocketUtils alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_SERVER]]];
        [instance open];
        NSLog(@"Socket open........");
    }
    instance.delegate = delegate;
    return instance;
}

+ (void)releaseInstance{
    instance = nil;
//    SocketUtils *socketUtils = [SocketUtils getInstance:nil];
//    socketUtils = nil;
    NSLog(@"Socket release........");
}

@end
