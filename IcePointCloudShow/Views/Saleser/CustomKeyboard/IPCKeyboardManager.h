//
//  IPCKeyboardManager.h
//  IcePointCloudShow
//
//  Created by gerry on 2017/12/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCKeyboardManager : NSObject

@property (nonatomic, assign) IPCEditKeyboardType      editType;

+ (IPCKeyboardManager *)sharedManager;

@end
