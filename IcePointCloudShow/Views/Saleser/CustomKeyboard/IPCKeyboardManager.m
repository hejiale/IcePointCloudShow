//
//  IPCKeyboardManager.m
//  IcePointCloudShow
//
//  Created by gerry on 2017/12/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCKeyboardManager.h"

@implementation IPCKeyboardManager

+ (IPCKeyboardManager *)sharedManager
{
    static IPCKeyboardManager *mgr = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        mgr = [[self alloc] init];
    });
    return mgr;
}

@end
