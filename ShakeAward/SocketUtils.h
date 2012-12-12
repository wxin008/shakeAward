//
//  SocketUtils.h
//  ShakeAward
//
//  Created by  on 12-12-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface SocketUtils : SRWebSocket

+ (SocketUtils *)getInstance : (id)delegate; 
+ (void)releaseInstance;
@end
